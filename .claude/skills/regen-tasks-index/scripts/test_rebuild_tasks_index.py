#!/usr/bin/env python3
"""Tests unitaires pour rebuild_tasks_index.py (T#83 — S77).

Couverture :
- parse_frontmatter : 16 cas (vide, sans delim, unclosed, string, quoted,
  int, neg int, bool, list, list quoted, list vide, comment, blank line,
  task réelle).
- sort_key : 7 cas (priorité, statut, ID num, ID suffix alpha, prio inconnue,
  prio manquante = P3, garde-fou lecture clé "fm" — anti-régression bug S76).
- status_emoji : 7 statuts connus + 2 inconnus.
- Constantes STATUS_ORDER / PRIO_ORDER : exhaustivité.

Lancement :
    python3 .claude/skills/regen-tasks-index/scripts/test_rebuild_tasks_index.py
"""

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from rebuild_tasks_index import (  # noqa: E402
    parse_frontmatter,
    sort_key,
    status_emoji,
    STATUS_ORDER,
    PRIO_ORDER,
)


class TestParseFrontmatter(unittest.TestCase):
    def test_empty_string(self):
        self.assertEqual(parse_frontmatter(""), {})

    def test_no_delimiter(self):
        self.assertEqual(parse_frontmatter("foo: bar\n"), {})

    def test_unclosed_frontmatter(self):
        self.assertEqual(parse_frontmatter("---\nfoo: bar\n"), {})

    def test_simple_string(self):
        self.assertEqual(parse_frontmatter("---\nfoo: bar\n---\n"), {"foo": "bar"})

    def test_double_quoted_string(self):
        self.assertEqual(
            parse_frontmatter('---\ntitle: "Hello world"\n---\n'),
            {"title": "Hello world"},
        )

    def test_single_quoted_string(self):
        self.assertEqual(
            parse_frontmatter("---\ntitle: 'Hello'\n---\n"), {"title": "Hello"}
        )

    def test_positive_integer(self):
        self.assertEqual(parse_frontmatter("---\nid: 42\n---\n"), {"id": 42})

    def test_negative_integer(self):
        self.assertEqual(parse_frontmatter("---\nfoo: -5\n---\n"), {"foo": -5})

    def test_boolean_true(self):
        self.assertEqual(
            parse_frontmatter("---\nactive: true\n---\n"), {"active": True}
        )

    def test_boolean_false(self):
        self.assertEqual(
            parse_frontmatter("---\nactive: false\n---\n"), {"active": False}
        )

    def test_list_basic(self):
        self.assertEqual(
            parse_frontmatter("---\ntags: [a, b, c]\n---\n"),
            {"tags": ["a", "b", "c"]},
        )

    def test_list_with_quotes(self):
        self.assertEqual(
            parse_frontmatter('---\ntags: ["a", "b"]\n---\n'),
            {"tags": ["a", "b"]},
        )

    def test_list_empty(self):
        self.assertEqual(parse_frontmatter("---\ntags: []\n---\n"), {"tags": []})

    def test_comments_skipped(self):
        self.assertEqual(
            parse_frontmatter("---\n# comment\nfoo: bar\n---\n"), {"foo": "bar"}
        )

    def test_blank_lines_skipped(self):
        self.assertEqual(
            parse_frontmatter("---\nfoo: bar\n\nbaz: qux\n---\n"),
            {"foo": "bar", "baz": "qux"},
        )

    def test_real_task_frontmatter(self):
        text = (
            "---\n"
            "id: 82\n"
            'title: "Decongestion METRIQUES.md"\n'
            "status: done\n"
            "priority: P2\n"
            "session_opened: S76\n"
            "tags: [metriques, decongestion]\n"
            "---\n"
            "body content\n"
        )
        result = parse_frontmatter(text)
        self.assertEqual(result["id"], 82)
        self.assertEqual(result["title"], "Decongestion METRIQUES.md")
        self.assertEqual(result["status"], "done")
        self.assertEqual(result["priority"], "P2")
        self.assertEqual(result["session_opened"], "S76")
        self.assertEqual(result["tags"], ["metriques", "decongestion"])


class TestSortKey(unittest.TestCase):
    @staticmethod
    def _task(**fm):
        return {"fm": fm}

    def test_priority_dominates(self):
        a = self._task(id=10, priority="P1", status="open")
        b = self._task(id=1, priority="P3", status="open")
        self.assertLess(sort_key(a), sort_key(b))

    def test_status_within_priority(self):
        a = self._task(id=20, priority="P2", status="in_progress")
        b = self._task(id=1, priority="P2", status="done")
        self.assertLess(sort_key(a), sort_key(b))

    def test_id_numeric_within_priority_status(self):
        a = self._task(id=5, priority="P2", status="open")
        b = self._task(id=10, priority="P2", status="open")
        self.assertLess(sort_key(a), sort_key(b))

    def test_id_alpha_suffix_after_pure(self):
        a = self._task(id="3", priority="P2", status="open")
        b = self._task(id="3b", priority="P2", status="open")
        self.assertLess(sort_key(a), sort_key(b))

    def test_unknown_priority_falls_last(self):
        known = self._task(id=1, priority="P3", status="open")
        unknown = self._task(id=1, priority="ZZZ", status="open")
        self.assertLess(sort_key(known), sort_key(unknown))

    def test_missing_priority_defaults_to_p3(self):
        no_prio = self._task(id=1, status="open")
        p2 = self._task(id=2, priority="P2", status="open")
        self.assertLess(sort_key(p2), sort_key(no_prio))

    def test_reads_fm_key_not_frontmatter(self):
        """Anti-regression bug latent S76 : sort_key DOIT lire t['fm'].

        Si quelqu'un renomme la cle en t['frontmatter'], ce test crashe.
        """
        task = {"fm": {"id": 1, "priority": "P1", "status": "open"}}
        result = sort_key(task)
        self.assertEqual(result[0], 1)  # P1 -> 1
        self.assertEqual(result[1], 1)  # open -> 1
        self.assertEqual(result[2], 1)  # id 1


class TestStatusEmoji(unittest.TestCase):
    def test_all_known_statuses(self):
        cases = {
            "in_progress": "\U0001F504",
            "open": "\U0001F7E2",
            "testing": "\U0001F9EA",
            "pending": "⏸️",
            "deferred": "⏭️",
            "done": "✅",
            "cancelled": "❌",
        }
        for status, emoji in cases.items():
            with self.subTest(status=status):
                self.assertEqual(status_emoji(status), emoji)

    def test_unknown_status_returns_question(self):
        self.assertEqual(status_emoji("foo"), "❓")

    def test_empty_status_returns_question(self):
        self.assertEqual(status_emoji(""), "❓")


class TestOrderConstants(unittest.TestCase):
    def test_status_order_covers_all_used_statuses(self):
        for s in (
            "in_progress",
            "open",
            "testing",
            "pending",
            "deferred",
            "done",
            "cancelled",
        ):
            self.assertIn(s, STATUS_ORDER)

    def test_prio_order_covers_p0_to_p3(self):
        for p in ("P0", "P1", "P2", "P3"):
            self.assertIn(p, PRIO_ORDER)

    def test_in_progress_sorts_first(self):
        self.assertEqual(STATUS_ORDER["in_progress"], 0)

    def test_p0_sorts_first(self):
        self.assertEqual(PRIO_ORDER["P0"], 0)


if __name__ == "__main__":
    unittest.main(verbosity=2)
