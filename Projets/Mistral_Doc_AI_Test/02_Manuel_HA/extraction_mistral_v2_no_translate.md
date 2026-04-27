Z-Wave - Home Assistant
Version: 2026.4.4
Getting started
This section shows how to set up a Z-Wave network and how to add a Z-Wave end device to that network.
A Z-Wave network in Home Assistant includes the following elements:
A Z-Wave adapter (for example, Home Assistant Connect ZWA-2)

A Z-Wave server (for example, the Z-Wave JS app)

This Z-Wave integration

Z-Wave end devices

Setting Up a Z-Wave Server in Home Assistant
To Set Up a Z-Wave Server
Open the Home Assistant user interface.

Plug the Z-Wave adapter into the device running Home Assistant.
Most likely, your adapter will be recognized automatically.

In the dialog, select Recommended installation.

This will install the Z-Wave JS app on the Home Assistant server.

Add the device to an area and select Finish.

Troubleshooting: If your adapter is not recognized, follow these steps.


Wait for the installation to complete.

Depending on your Home Assistant version, you may be prompted for network security keys.
If you are using Z-Wave for the first time, leave all the fields empty and select Submit. The system will generate network security keys for you.

If this Z-Wave adapter has already been paired with secure devices, you need to enter the previously used network key as the S0 network key. S2 security keys will be automatically generated for you.

Note: Keep a backup of these keys in a safe place in case you need to move your Z-Wave adapter to another device.


Note
While your Z-Wave mesh is permanently stored on your adapter, the additional metadata is not. When the Z-Wave integration starts up the first time, it will interview your entire Z-Wave network. Depending on the number of devices paired with the Z-Wave adapter, this can take a while. You can speed up this process by manually waking up your battery-powered devices. Most of the time, this is a button press on those devices (see their manual). It is not necessary to exclude and re-include devices from the mesh.

Adding a New Device to the Z-Wave Network
In Home Assistant, go to Settings > Z-Wave.

Select Add device.
The Z-Wave adapter is now in inclusion mode.


Check if your device supports SmartStart:
On the packaging, check for the SmartStart label.

Find the QR code. It can be on the packaging or on the device itself.


Depending on whether your device supports SmartStart, follow the steps in either Option 1 or Option 2:
Option 1: Your device supports SmartStart
Make sure the device is turned off.

Mesh: If you already have a mesh network, adding it can enhance coverage and reliability of this network.

You can always remove and pair the device again to switch to the other network type.

Turn the device on and set it into inclusion mode.

If it was already on, you might need to power-cycle it.

 Option 2: Your device does not support SmartStart
Set the device in inclusion mode. Refer to the device manual to see how this is done.

If your device is included using S2 security, you may be prompted to enter a PIN number provided with your device. Often, this PIN is provided with the documentation and is also printed on the device itself.


The UI should confirm that the device was added. After a short while (seconds to minutes), the entities should also be created.

Troubleshooting: If the adapter fails to add/find your device, cancel the inclusion process.
In some cases, it might help to first remove a device (exclusion) before you add it, even when the device has not been added to this Z-Wave network yet.

Another approach would be to factory reset the device. Refer to the device manual to see how this is done.


Removing a Device from the Z-Wave Network
Do this before using the device with another adapter, or when you don't use the device anymore. It removes the device from the Z-Wave network stored on the adapter. It also removes the device and all its entities from Home Assistant. You cannot join a device to a new network if it is still paired with an adapter.
In Home Assistant, go to Settings > Devices & services.

Select the Z-Wave integration.
Then, select the device you want to remove.


Under Device info, select the three-dot menu, then select Delete.
This opens a dialog with options for removing the device.


Select Remove a working device.
The Z-Wave adapter is now in exclusion mode.


Put the device you want to remove in exclusion mode. Refer to its manual to learn how this is done.

The UI should confirm that the device was removed and the device and entities will be removed from Home Assistant.

Removing a Device from a Foreign Z-Wave Network
Do this when you have a device that is still paired with an adapter, but you don't have access to that adapter anymore. If the device was not excluded from that adapter, you cannot join it to a new network. This process removes the device from the previous adapter's network, allowing you to pair it with a new adapter.
Migrating a Z-Wave Network to a New Adapter
Do this if you have an existing Z-Wave network and want to replace its adapter with a new adapter. The Z-Wave integration with all its entities will stay in Home Assistant. The new adapter is added to Home Assistant and paired with the existing network.
Prerequisites
Administrator rights in Home Assistant

Device-Specific Prerequisites
In Home Assistant, go to Settings > Z-Wave.

Under Migrate adapter, select Migrate.

When the Unplug your adapter dialog shows up, unplug your old adapter.
It is important to remove the old device now, as it might interfere with the new one. Even though it might not throw an error immediately, it might cause issues.


Connect the new adapter.

Select Submit.

In the Select your device dialog, select the Z-Wave adapter you just connected.
Typically, you can select the device you connected to a USB port.

To connect to a Z-Wave controller that you exposed elsewhere via TCP (such as Portable Z-Wave), select the Use socket option.


Select Submit.
The new adapter is now being paired with your existing Z-Wave network.

Troubleshooting: If the migration fails, it might be because you selected Use socket by mistake. If you were using a USB-based controller, plug the old adapter in again, and wait for the network to reload.

Once your old adapter is connected and the network is operational, repeat the migration steps.

Make sure to select the new controller this time (instead of Use socket).


Migrating from Z-Wave JS UI to the Z-Wave JS App
If you have been using the Z-Wave JS UI app, you can migrate to the Z-Wave JS app without needing to re-pair your devices. The Z-Wave JS app is the successor of the Z-Wave JS UI app and provides a better experience and more features. The migration process involves installing the Z-Wave JS app, which will automatically take over from the Z-Wave JS UI app.
Prerequisites
Administrator rights in Home Assistant

Your Z-Wave network is currently managed by the Z-Wave JS UI app

Installing Necessary Apps
In Home Assistant, go to Settings > Apps > Z-Wave JS.

Install the Z-Wave JS app by selecting Install.
Do not start the app yet.


Install necessary helper apps:
Install the Terminal & SSH app so you can run commands on the Home Assistant host.

Install an app that lets you upload and edit files on the Home Assistant host, like the File Editor app or the Studio Code Server app.


Downloading a Backup
[IMAGE: Backup button in Z-Wave JS UI]
Running the Migration Script
Upload the backup file and the migration script into a temporary folder, ideally the /tmp folder.

Open the terminal, then use cd /tmp to navigate to the /tmp folder.

Make the script executable by running chmod +x ./migrate_to_zwave_js_app.sh.

Reconfiguring the Z-Wave Integration to Use the Z-Wave JS App
Go to Settings > Devices & services.

Select the three dots menu, then choose Reconfigure.

[IMAGE: Z-Wave integration needs attention]
Depending on how your controller is connected, you might need to either select or clear the Use the Z-Wave Supervisor app checkbox.
Option 1: If you are using a USB-based or TCP-based controller:
Select the Use the Z-Wave Supervisor app checkbox.

In the next step, select your controller and select Submit.

 Option 2: If you are using a GPIO module or if your controller is not showing up in the list:
Clear the Use the Z-Wave Supervisor app checkbox.

Enter the connection details for your Z-Wave JS app:
In the URL field, enter ws://core-zwave-js:3000.



Overriding the Radio Frequency Region of the Adapter in the Z-Wave JS App
The frequency used by Z-Wave devices depends on your region. For 700 and 800 series adapters, this frequency can be changed. The frequency of end devices cannot, so you need to make sure to buy devices specific to your region.
If you are using the Z-Wave JS app, Home Assistant automatically changes the radio frequency region to match the region/country you're in. If needed, you can override this setting.
Prerequisites
Administrator rights in Home Assistant

All your Z-Wave devices must be specified for that region

Note: This procedure only applies if your adapter is set up using the Z-Wave JS app.

To Override the Radio Frequency Region of Your Z-Wave Adapter
Go to Settings > Apps > Z-Wave JS.

Open the Configuration tab.

Under Radio Frequency Region, select your region.
Note: If you select Long Range, you can only add devices that support Long Range.

Even with the Long Range option selected, you can still add devices that don't support Long Range.


To apply your changes, select Save.
Your Z-Wave adapter is now ready to communicate with devices that were specified for your chosen region.


To return to the default setting and use the region defined by Home Assistant, under Radio Frequency Region choose Automatic.

Backing Up Your Z-Wave Network
It's recommended to create a backup before making any major changes to your Z-Wave network. For example, before migrating from one adapter to another, or before resetting your adapter. The backup stores your Z-Wave adapter's non-volatile memory (NVM), which contains your network information including paired devices. It is stored in a binary file that you can download.
Prerequisites
Administrator rights in Home Assistant

To Backup Your Z-Wave Network
In Home Assistant, go to Settings > Z-Wave.

Restoring a Z-Wave Network from Backup
Prerequisites
Administrator rights in Home Assistant

Have a backup downloaded

To Restore a Z-Wave Network from Backup
In Home Assistant, go to Settings > Z-Wave.

Under Restore from backup, select Restore.
Select the backup you want to restore from.

Result: The Z-Wave network is being restored and the devices that were part of the network should show up again.


Updating the Firmware of Your Z-Wave Device
Adapters and devices with the Firmware Update Metadata Command Class allow you to update the firmware by uploading a firmware file. In those cases, you can start the firmware update from the device page in Home Assistant. Refer to the documentation of the device manufacturer to find the corresponding firmware file. An example is the firmware page by Zooz.
Note
The Home Assistant and Z-Wave JS teams do not take any responsibility for any damages to your device as a result of the firmware update and will not be able to help you if you render your device useless due to firmware update.

Prerequisites
Administrator rights in Home Assistant

Downloaded the firmware file from the manufacturer website

To Update Firmware of a Z-Wave Device
In Home Assistant, go to Settings > Z-Wave.

Select Devices.
Then select the device you want to update.


Under Device info, select the three-dot menu, then select Update.

Select the firmware file that you previously downloaded to your computer.
Notice: Risk of damage to the device

Make sure you select the correct firmware file.

An incorrect firmware file can damage your device.

Once you start the update process, you must wait for the update to complete.

An interrupted update can damage your device.


Resetting a Z-Wave Adapter
Prerequisites
Administrator rights on Home Assistant

Backup your Z-Wave network

Remove all devices that are paired with your adapter from the network.
Removing can be done by any adapter, not just the one that originally managed the network. In theory, this could also be done later.


To Reset a Z-Wave Adapter
In Home Assistant, go to Settings > Devices & services.

Select the Z-Wave integration. Then, select the controller.

Under Device info, select the three-dot menu, then select Factory reset.

On the device info page, check the Activity panel. When you see that the status entity became unavailable, the reset process is finished.
You can now unplug the adapter and use it to start a new network, or pass it on to someone else.


If you no longer need the Z-Wave integration, you can remove it from Home Assistant.

Special Z-Wave Entities
The Z-Wave integration provides several special entities, some of which are available for every Z-Wave device, and some of which are conditional based on the device.
Entities Available for Every Z-Wave Device
Node status sensor: This sensor shows the node status for a given Z-Wave device. The sensor is disabled by default. The available node statuses are explained in the Z-Wave JS documentation. They can be used in state change automations. For example, to ping a device when it is dead, or refresh values when it wakes up.

Conditional Entities
Button to manually idle notifications: Any Notification Command Class (CC) values on a device that have an idle state will get a corresponding button entity. This button entity can be used to manually idle a notification when it doesn't automatically clear on its own. A device can have multiple Notification CC values. For example, one for detecting smoke and one for detecting carbon monoxide.

Using Advanced Features (UI Only)
While the integration aims to provide as much functionality as possible through existing Home Assistant constructs (entities, states, automations, actions, etc.), there are some features that are only available through the UI.
All of these features can be accessed either in the Z-Wave integration configuration panel or in a Z-Wave device's device panel.
Integration Configuration Panel
The following features can be accessed from the integration configuration panel:
Add device: Button in the bottom-right corner. Allows you to pre-provision a SmartStart device or start the inclusion process for adding a new device to your network.

The My network section gives you access to the device and entity lists for your Z-Wave network.
Show map: Allows you to see a visual representation of your Z-Wave network, showing the devices and the routes between them. This can be helpful to troubleshoot issues in your network.

Options > Remove device: Starts the exclusion process for removing a foreign device from a network. This allows you to remove a device that is still paired to another Z-Wave adapter.

Options > Discover and assign new routes: Discovers new routes between the adapter and the device. This is useful when devices or the adapter have moved, or when you suspect RF issues.

About Network Information
The Network information section in the integration configuration panel shows metadata about your Z-Wave network and the software running it. This information is useful when troubleshooting issues or when contacting support.
Home ID: A unique identifier assigned to your Z-Wave network. Every device paired to your network shares this ID. It can be used to verify that a device belongs to your network or to identify your network when seeking help.

Integration Menu
Some features can be accessed from the menu of the integration itself. As they are not specific to Z-Wave, they are not described here in detail.
Download diagnostics: Exports a JSON file describing the entities of all devices registered with this integration.

Network Devices
The following features can be accessed from the device panel of any Z-Wave device on your network aside from the adapter:
Configure: Provides an easy way to look up and update configuration parameters for the device. While there is an existing action for setting configuration parameter values, this UI may sometimes be quicker to use for one-off changes.

Re-interview: Forces the device to go through the interview process again so that Z-Wave-JS can discover all of its capabilities. Can be helpful if you don't see all the expected entities for your device.

Rebuild routes: Discovers new routes between the adapter and the device. Use this if you think you are experiencing unexpected delays or RF issues with your device. Your device may be less responsive during this process.

Delete: Opens a dialog with the following options for removing the device:
Removing it from the network using exclusion

Removing a failed device from the adapter without excluding it from the network


Statistics: Provides statistics about communication between this device and the adapter, allowing you to troubleshoot RF issues with the device.

Update: Updates a device's firmware using a manually uploaded firmware file. Only some devices support this feature (adapters and devices with the Firmware Update Metadata Command Class).

Download diagnostics: Exports a JSON file describing the entities of this specific device.

Actions
Action: Set Config Parameter
Data attribute
Required
Description
entity_id
no
Entity (or list of entities) to set the configuration parameter on. At least one entity_id, device_id, or area_id must be provided.
device_id
no
Device ID (or list of device IDs) to set the configuration parameter on. At least one entity_id, device_id, or area_id must be provided.
area_id
no
Area ID (or list of area IDs) for devices/entities to set the configuration parameter on. At least one entity_id, device_id, or area_id must be provided.
parameter
yes
The parameter number or the name of the property. The name of the property is case sensitive.
bitmask
no
The bitmask for a partial parameter in hex (0xff) or decimal (255) format. If the name of the parameter is provided, this is not needed. Cannot be combined with value_size or value_format.
value
yes
The target value for the parameter as the integer value or the state label. The state label is case sensitive.
value_size
no
The size of the target parameter value, either 1, 2, or 4. Used in combination with value_format when a config parameter is not defined in your device's configuration file. Cannot be combined with bitmask.
Example 1:
YAML
action: zwave_js.set_config_parameter
target:
  entity_id: switch.fan
data:
  parameter: 31
  bitmask: 0x01
  value: 1


Example 2:
YAML
action: zwave_js.set_config_parameter
target:
  entity_id: switch.fan
data:
  parameter: 31
  bitmask: 1
  value: "Blink"


Example 3:
YAML
action: zwave_js.set_config_parameter
target:
  entity_id: switch.fan
data:
  entity_id: switch.fan
  parameter: "LED 1 Blink Status (bottom)"
  value: "Blink"


Action: Bulk Set Partial Config Parameters
Data attribute
Required
Description
entity_id
no
Entity (or list of entities) to bulk set partial configuration parameters on. At least one entity_id, device_id, or area_id must be provided.
device_id
no
Device ID (or list of device IDs) to bulk set partial configuration parameters on. At least one entity_id, device_id, or area_id must be provided.
area_id
no
Area ID (or list of area IDs) for devices/entities to bulk set partial configuration parameters on. At least one entity_id, device_id, or area_id must be provided.
parameter
yes
The parameter number of the property. The name of the property is case sensitive.
value
yes
Either the raw integer value that you want to set for the entire parameter, or a dictionary where the keys are either the bitmasks (in integer or hex form) or the partial parameter name and the values are the value you want to set on each partial (either the integer value or a named state when applicable). Note that when using a dictionary, and bitmasks that are not provided will be set to their currently cached values.
Example 1:
YAML
action: zwave_js.bulk_set_partial_config_parameters
target:
  entity_id: switch.fan
data:
  parameter: 21
  value: 4735


Example 2:
YAML
action: zwave_js.bulk_set_partial_config_parameters
target:
  entity_id: switch.fan
data:
  parameter: 21
  value:
    0xff: 127
    0x7f00: 10
    0x8000: 1


Example 3:
YAML
action: zwave_js.bulk_set_partial_config_parameters
target:
  entity_id: switch.fan
data:
  parameter: 21
  value:
    255: 127
    32512: 10


Example 4:
YAML
action: zwave_js.bulk_set_partial_config_parameters
target:
  entity_id: switch.fan
data:
  parameter: 21
  value:
    "Quick Strip Effect: Hue Color Wheel / Color Temp": 127
    "Quick Strip Effect Intensity": 10
    "Quick Strip Effect Intensity Scale": "Fine"


Action: Refresh Value
The zwave_js.refresh_value action refreshes the value(s) for an entity. This action will generate extra traffic on your Z-Wave network and should be used sparingly. Updates from devices on battery may take some time to be received.
Data attribute
Required
Description
entity_id
yes
Entity or list of entities to refresh values for.
refresh_all_values
no
Whether all values should be refreshed. If false, only the primary value will be refreshed. If true, all watched values will be refreshed.
Action: Set Value
The zwave_js.set_value action sets a value on a Z-Wave device. It is for advanced use.
Data attribute
Required
Description
entity_id
no
Entity (or list of entities) to set the value on. At least one entity_id, device_id, or area_id must be provided.
device_id
no
Device ID (or list of device IDs) to set the value on. At least one entity_id, device_id, or area_id must be provided.
area_id
no
Area ID (or list of area IDs) for devices/entities to set the value on. At least one entity_id, device_id, or area_id must be provided.
command_class
yes
ID of Command Class that you want to set the value for.
property
yes
ID of Property that you want to set the value for.
property_key
no
ID of Property Key that you want to set the value for.
endpoint
no
ID of Endpoint that you want to set the value for.
value
yes
The new value that you want to set.
options
no
Set value options map. Refer to the Z-Wave JS documentation for more information on what options can be set.
wait_for_result
no
Boolean that indicates whether or not to wait for a response from the node. If not included in the payload, the integration will decide whether to wait or not. If set to true, note that the action can take a while if setting a value on an asleep battery device.
Action: Multicast Set Value
Data attribute
Required
Description
entity_id
no
Entity (or list of entities) to set the value on via multicast. At least two entity_id or device_id must be resolved if not broadcasting the command.
device_id
no
Device ID (or list of device IDs) to set the value on via multicast. At least two entity_id or device_id must be resolved if not broadcasting the command.
area_id
no
Area ID (or list of area IDs) for devices/entities to set the value on via multicast. At least two entity_id or device_id must be resolved if not broadcasting the command.
broadcast
no
Boolean that indicates whether you want the message to be broadcast to all nodes on the network. If you have only one Z-Wave network configured, you do not need to provide a device_id or entity_id when this is set to true. When you have multiple Z-Wave networks configured, you MUST provide at least one device_id or entity_id so the action knows which network to target.
command_class
yes
ID of Command Class that you want to set the value for.
property
yes
ID of Property that you want to set the value for.
property_key
no
ID of Property Key that you want to set the value for.
Action: Invoke CC API
The zwave_js.invoke_cc_api action uses the Command Class API directly. In most cases, the zwave_js.set_value action will accomplish what you need, but some Command Classes have API commands that can't be accessed via that action. Refer to the Z-Wave JS Command Class documentation for the available APIs and arguments.
Data attribute
Required
Description
entity_id
no
Entity (or list of entities) to ping. At least one entity_id, device_id, or area_id must be provided. If endpoint is specified, that endpoint will be used to make the CC API call for all devices, otherwise the primary value endpoint will be used for each entity.
device_id
no
Device ID (or list of device IDs) to ping. At least one entity_id, device_id, or area_id must be provided. If endpoint is specified, that endpoint will be used to make the CC API call for all devices, otherwise the root endpoint (0) will be used for each device.
area_id
no
Area ID (or list of area IDs) for devices/entities to ping. At least one entity_id, device_id, or area_id must be provided. If endpoint is specified, that endpoint will be used to make the CC API call for all devices, otherwise the root endpoint (0) will be used for each zwave_js device in the area.
command_class
yes
ID of Command Class that you want to set the value for.
endpoint
no
The endpoint to call the CC API against.
Action: Refresh Notifications
Data attribute
Required
Description
entity_id
no
Entity (or list of entities) to refresh notifications for. At least one entity_id, device_id, or area_id must be provided.
device_id
no
Device ID (or list of device IDs) to refresh notifications for. At least one entity_id, device_id, or area_id must be provided.
area_id
no
Area ID (or list of area IDs) for devices/entities to refresh notifications for. At least one entity_id, device_id, or area_id must be provided.
notification_type
yes
The type of notification to refresh.
notification_event
no
The notification event to refresh.
Action: Reset Meter
The zwave_js.reset_meter action resets the meters on a device that supports the Meter Command Class.
Data attribute
Required
Description
entity_id
yes
Entity (or list of entities) for the meters you want to reset.
meter_type
no
If supported by the device, indicates the type of meter to reset. Not all devices support this option.
Action: Set Lock Operation
Data attribute
Required
Description
entity_id
no
Lock entity or list of entities to set the lock operation.
operation_type
yes
Lock operation type, one of timed or constant.
lock_timeout
no
Seconds until lock mode times out. Should only be used if operation type is timed.
auto_relock_time
no
Duration in seconds until lock returns to secure state. Only enforced when operation type is constant.
hold_and_release_time
no
Duration in seconds the latch stays retracted.
twist_assist
no
Enable Twist Assist.
block_to_block
no
Enable block-to-block functionality.
Action: Set Lock Usercode
The zwave_js.set_lock_usercode action sets the usercode of a lock to X at code slot Y. Valid usercodes are at least 4 digits.
Data attribute
Required
Description
entity_id
no
Lock entity or list of entities to set the usercode.
code_slot
yes
The code slot to set the usercode into.
usercode
yes
The code to set in the slot.
Action: Clear Lock Usercode
The zwave_js.clear_lock_usercode action clears the usercode of a lock at code slot X.
Data attribute
Required
Description
entity_id
no
Lock entity or list of entities to clear the usercode.
code_slot
yes
The code slot to clear.
Action: Get Lock Usercode
The zwave_js.get_lock_usercode action retrieves usercodes from a lock. You can query a specific code slot or retrieve all code slots at once. Returns the usercode and in-use status for each slot.
Data attribute
Required
Description
entity_id
no
Lock entity or list of entities to get usercodes from.
code_slot
no
The code slot to retrieve. If not specified, all code slots are returned.
Events
There are two types of events that are fired: notification events and value notification events. You can test what events come in using the event developer tools in Home Assistant and subscribing to the zwave_js_notification or zwave_js_value_notification events respectively. Once you know what the event data looks like, you can use this to create automations.
Node Events (Notification)
Check the Z-Wave JS notification event documentation for an explanation of the event types.
YAML
event_type: zwave_js_notification
event_data:
  node_id: 14
  event_label: "Keypad unlock operation"


Notification Command Class
These are notification events fired by devices using the Notification Command Class. The (parameters) attribute in the example below is optional, and when it is included, the keys in the attribute will vary depending on the event.
JSON
{
  "domain": "zwave_js",
  "node_id": 1,
  "endpoint": 0,
  "home_id": "974823419",
  "device_id": "ad8098fe80980974",
  "command_class": 113,
  "command_class_name": "Notification",
  "type": 6,
  "event": 5,
  "label": "Access Control",
  "event_label": "Keypad lock operation",
  "parameters": {"userId": 1}
}


Multilevel Switch Command Class
These are notification events fired by devices using the Multilevel Switch Command Class. There are events for start level change and stop level change. These would typically be used in a device like the Aeotec Nano Dimmer with an external switch to respond to long button presses.
Start level change
JSON
{
  "domain": "zwave_js",
  "node_id": 8,
  "endpoint": 0,
  "home_id": 3803689189,
  "device_id": "2f44f0d4152be3123f7ad40cf3abd095",
  "command_class": 38,
  "command_class_name": "Multilevel Switch",
  "event_type": 1,
  "event_type_label": "label 1",
  "direction": "up"
}


Stop level change
JSON
{
  "domain": "zwave_js",
  "node_id": 8,
  "endpoint": 0,
  "home_id": 3803689189,
  "device_id": "2f44f0d4152be3123f7ad40cf3abd095",
  "command_class": 38,
  "command_class_name": "Multilevel Switch",
  "event_type": 5,
  "event_type_label": "label 2",
  "direction": null
}


Entry Control Command Class
These are notification events fired by devices using the Entry Control Command Class.
JSON
{
  "domain": "zwave_js",
  "node_id": 1,
  "endpoint": 0,
  "home_id": "974823419",
  "device_id": "ad8098fe80980974",
  "command_class": 111,
  "command_class_name": "Entry Control",
  "event_type": 6,
  "event_type_label": "label 1",
  "data_type": 5,
  "data_type_label": "label 2"
}


Central Scene Command Class
These are notification events fired by devices using the Central Scene Command Class.
JSON
{
  "domain": "zwave_js",
  "node_id": 1,
  "home_id": "974823419",
  "endpoint": 0,
  "device_id": "ad8098fe80980974",
  "command_class": 91,
  "command_class_name": "Central Scene",
  "label": "Event value",
  "property": "scene",
  "property_name": "scene",
  "property_key": "001",
  "property_key_name": "001",
  "value": "KeyPressed",
  "value_raw": 0
}


Value Updated Events
Due to some devices not following the Z-Wave Specification, there are scenarios where a device will send a value update but a state change won't be detected in Home Assistant. To address the gap, the zwave_js_value_updated event can be listened to to capture any value updates that are received by an affected entity. This event is enabled on a per device and per entity domain basis, and the entities will have assumed_state set to true. This change will affect how the UI for these entities look; if you'd like the UI to match other entities of the same type where assumed_state is not set to true, you can override the setting via entity customization.
The following devices currently support this event:
Txt
Mala
Model
Entity Domain


JSON
{
  "domain": "zwave_js",
  "node_id": 1,
  "endpoint": 0,
  "device_id": "ad8098fe80980974",
  "command_class": 48,
  "command_class_name": "Sensor Multilevel",
  "property": "currentValue",
  "property_name": "currentValue",
  "property_key": null,
  "property_key_name": null,
  "value": 0,
  "value_raw": 0
}


This event can be used to trigger a refresh of values when the new state needs to be retrieved. Here's an example automation:
YAML
triggers:
  - trigger: event
    event_type: zwave_js_value_updated
    event_data:
      entity_id: switch.in_wall_dual_relay_switch
actions:
  - action: zwave_js.refresh_value
    data:
      entity_id:
        - switch.in_wall_dual_relay_switch_2
        - switch.in_wall_dual_relay_switch_3


Automations
The Z-Wave integration provides its own trigger platforms which can be used in automations.
zwave_js.value_updated
YAML
# At least one `device_id` or `entity_id` must be provided
device_id: 45d7d3230dbb7441473ec883dab294d4 # Garage Door Lock device ID
entity_id:
  - lock.front_lock
  - lock.back_door
# `property` and `command_class` are required
command_class: 98 # Door Lock CC
property: "latchStatus"
# `property_key` and `endpoint` are optional
property_key: null
endpoint: 0
# `from` and `to` will both accept lists of values and the trigger will fire if the
# value update matches any of the listed values
from:
  - "closed"
  - "jammed"
to: "opened"


Available Trigger Data
In addition to the standard automation trigger data, the zwave_js.value_updated trigger platform has additional trigger data available for use.
Template variable
Data
trigger_device_id
Device ID for the device in the device registry.
trigger.node_id
Z-Wave node ID.
trigger.command_class
Command Class ID.
trigger.command_class_name
Command Class name.
trigger.property
Z-Wave Value's property.
trigger.property_name
Z-Wave Value's property name.
trigger.property_key
Z-Wave Value's property key.
trigger.property_key_name
Z-Wave Value's property key name.
trigger.current_value
Current value.
trigger.current_value_raw
Current raw value.
zwave_js.event
This trigger platform can be used to trigger automations on any Z-Wave JS controller, driver, or node event, including events that may not be handled by Home Assistant automatically. Refer to the Z-Wave JS documentation to learn more about the available events and the data that is sent along with it.
There is strict validation in place based on all known event types, so if you come across an event type that isn't supported, please open a GitHub issue in the home-assistant/core repository.
Example Automation Trigger Configuration
YAML
# Fires whenever the `interview failed` event is fired on the three devices
# (devices will be derived from device and entity IDs).
triggers:
  - trigger: zwave_js.event
    # At least one `device_id` or `entity_id` must be provided for `node` events.
    # For any other events, a `config_entry_id` needs to be provided.
    device_id: 45d7d3230dbb7441473ec883dab294d4 # Garage Door Lock device ID
    entity_id:
      - lock.front_lock
      - lock.back_door
    config_entry_id:
    args:
      isFinal: true
      partial_dict_match: true  # defaults to false


Available Trigger Data
In addition to the standard automation trigger data, the zwave_js.event trigger platform has additional trigger data available for use.
Template variable
Data
trigger_device_id
Device ID for the device in the device registry (only included for node events).
trigger.node_id
Z-Wave node ID (only included for node events).
trigger.event_source
Source of event (node, controller, or driver).
trigger.event
Name of event.
trigger.event_data
Any data included in the event.
Advanced Installation Instructions
If you are using Home Assistant Container or you do not want to use the built-in Z-Wave JS app, you need to run the Z-Wave JS Server yourself, which the Z-Wave integration will connect to.
Running Z-Wave JS Server
Option 1: The Official Z-Wave JS App
This option is only available for Home Assistant Operating System (the recommended installation type) installations.
This app (formerly known as an add-on) can only be configured via the built-in Z-Wave control panel in Home Assistant. If you followed the standard installation procedure, this is how you are running the Z-Wave JS server.
Option 2: The Z-Wave JS UI Docker Container
This is considered a more involved use case. In this case, you run the Z-Wave JS Server or Z-Wave JS UI NodeJS application directly. Installation and maintaining this is out of scope for this document. See the Z-Wave JS server or Z-Wave JS UI GitHub repository for information.
Note
Supported Z-Wave adapter. The Z-Wave adapter should be connected to the same host as where the Z-Wave JS server is running. In the configuration for the Z-Wave JS server, you need to provide the path to this adapter. It's recommended to use the /dev/serial-by-id/yourdevice version of the path to your adapter, to make sure the path doesn't change over reboots. The most common known path is /dev/serial/by-id/usb-0658_0200-if00.

Note
Network keys are used to connect securely to compatible devices. The network keys consist of 32 hexadecimal characters, for example, 2232666D100F795E5BB17F0A1BB7A146 (do not use this one, pick a random one). Without network keys, security-enabled devices cannot be added securely and will not function correctly. You must provide these network keys in the configuration part of the Z-Wave JS Server.

For new installations, unique default keys will be auto-generated for you by the Z-Wave JS server.
Once you have the Z-Wave JS server up and running, you need to install and configure the integration in Home Assistant (as described above).
If you're running full Home Assistant with supervisor, you will be presented with a dialog that asks if you want to use the Z-Wave JS Supervisor app. You must uncheck this box if you are running the Z-Wave JS server in any manner other than the official Z-Wave JS app, including using Z-Wave JS UI app.
If you're not running the supervisor or you've unchecked the above-mentioned box, you will be asked to enter a WebSocket URL (defaults to ws://localhost:3000). It is very important that you fill in the correct (Docker) IP/hostname here. For example, for the Z-Wave JS UI app this is ws://a0d7b954-zwavejs2mqtt:3000.
FAQ: Supported Devices and Command Classes
For a list of supported devices, refer to the Z-Wave JS device database.
While there is support for the most common devices, some Command Classes are not yet (fully) implemented in Z-Wave JS. You can track the status here.
You can also check the list of Z-Wave Command Classes Home Assistant responds to when queried towards the end of this page.
You can also keep track of the road map for the Z-Wave integration here.
Why Was I (Not) Automatically Prompted to Install Z-Wave?
Some Z-Wave adapters can be auto-discovered, which can simplify the Z-Wave setup process. The following devices have been tested with discovery, and offer a quick setup experience; however, these are not all of the devices supported by Z-Wave:
Device
Identifier
Vendor
Aeotec Z-Stick Gen5+
0658:0200
Aeotec
Nortek HUSBZB-1
10C4:8A2A
Nortek Control
Zooz ZST10
10C4:EA60
Zooz
Z-WaveMe UZB
0658:0200
Z-Wave.Me
Additional devices may be discoverable, however only devices that have been confirmed discoverable are listed above.
Should I Use Secure Inclusion?
That depends. There are two generations of Z-Wave encryption: Security S0 and Security S2. Both provide encryption and allow detecting packet corruption.
Security S0 imposes significant additional traffic on your mesh and is recommended only for older devices that do not support Security S2 but require encryption to work, such as door locks.

Security S2 does not impose additional network traffic and provides additional benefits. For example, end devices using S2 require the hub to report whether it has received and understood their reports.

By default, Z-Wave prefers Security S2, if supported. Security S0 is used only when absolutely necessary.
Where Can I See the Security Keys in the Z-Wave JS App?
After the initial setup of the Z-Wave adapter, you can view the security keys in the Z-Wave JS app. Go to Settings > Apps > Z-Wave JS and open the Configuration tab. You can now see the three S2 keys and the S0 key. The network security key is a legacy configuration setting, identical to the S0 key.
My Z-Wave Adapter Isn't Recognized Automatically During Setup
If your Z-Wave adapter doesn't show up in the Discovered section automatically, try adding it manually:
Check the hardware:
Make sure the adapter is powered on.

Make sure the cable you are using supports data, not power only.


Go to Settings > Devices & services.

In the bottom right, select the Add Integration button and select Z-Wave.

Follow the instructions on screen to complete the setup.

If it is still not discovered, check for interference.

I Have an Aeotec Gen5 Adapter, and It Isn't Working
Make sure you are using a USB extension cable to avoid interference.

Try a different USB port.

Check if the adapter is recognized by your system.

My Device Doesn't Automatically Update Its Status in HA If I Control It Manually
Your device might not send automatic status updates to the adapter. While the best advice would be to update to recent Z-Wave Plus devices, there is a workaround with active polling (request the status).
Z-Wave does not automatically poll devices on a regular basis. Polling can quickly lead to network congestion and should be used very sparingly and only where necessary.
We provide a zwave_js.refresh_value action to manually poll a value, for example from an automation that only polls a device when there is motion in that same room.

Z-Wave JS allows you to configure scheduled polling on a per-value basis, which you can use to keep certain values updated. It also allows you to poll individual values on-demand from your automations, which should be preferred over blindly polling all the time if possible.

My Device Is Recognized as Unknown Manufacturer and/or Some Functions Don't Work with the Z-Wave Integration
When your device is not yet fully interviewed, this info will not yet be present. So make sure your device is interviewed at least once.
If the interview is complete, then the device does not yet have a device file for Z-Wave JS. Unlike other Z-Wave drivers, your device may very well work as intended even without such a file. If your device is not fully supported, consider contributing the device configuration file.
How Do I Get a Dump of the Current Network State?
When trying to determine why something isn't working as you expect, or when reporting an issue with the integration, it is helpful to know what Z-Wave JS sees as the current state of your Z-Wave network. To get a dump of your current network state, follow these steps:
Go to Settings > Devices & services.

Select the Z-Wave integration. Then, select the three-dot menu.

From the dropdown menu, select Download diagnostics.

How Do I Address Interference Issues?
Go to the Z-Wave integration panel: SHOW INTEGRATION ON MY.

In the top-right corner, select the three dots menu and select Enable debug logging.
Result: The log level will be set to debug for the integration, library, and optionally the driver (if the driver log level is not already set to verbose, debug, or silly), and all Z-Wave JS logs will be added to the Home Assistant logs.


If you want to change the log level, on the Z-Wave integration panel: SHOW INTEGRATION ON MY, select the cogwheel @.
Select the Logs tab, then select the log level.


Disable Z-Wave JS Logging
Go to the Z-Wave integration panel: SHOW INTEGRATION ON MY.

In the top-right corner, select the three dots menu and select Disable debug logging.
Result: The log level will be reset to its previous value for the integration, library, and driver, and the Home Assistant frontend will automatically send you the Z-Wave logs generated during that time period for download.


The Advanced Way
Enable Z-Wave JS logging manually, or via an automation:
Set the log level for zwave_js_server to a level higher than debug. This can either be done in your configuration.yaml in the logger section, or using the logger.set_level action. The Z-Wave JS logs will no longer be included in the Home Assistant logs, and if the log level of Z-Wave JS was changed by the integration, it will automatically change back to its original level.
Unsupported Functionality
This section lists functionality that is available in Z-Wave but that is not currently supported in Home Assistant.
Setting the Adapter into Learn Mode to Receive Network Information
In Home Assistant, it is currently not possible to set the Z-Wave controller into learn mode to receive network information from another controller.
Including/Excluding an Adapter in an Existing Network Using Classic Inclusion
A Z-Wave controller that manages an empty network can also join a different network and act as a secondary controller there. However, with Home Assistant, this is not possible. Home Assistant does not allow the Z-Wave controller to join another network, because Home Assistant acts as the central hub.
Identification via Z-Wave
Other Z-Wave devices can instruct a Home Assistant instance to identify itself by sending the following [Indicator Set] Z-Wave command (all bytes are hexadecimal):
Texte brut
87010003500308500403500506


The bytes underlined with ~ can also have any other value.
When receiving such a command, Home Assistant will show a notification in its sidebar, mentioning which node sent the command.
Z-Wave Command Classes Home Assistant Responds to When Queried
The following table lists the Command Classes together with the implemented version and required security class. These are the Command Classes that Home Assistant will respond to when queried by other devices.
Command Class
Version
Security Class
Association
4
Highest granted
Association Group Information
3
Highest granted
Multi Channel Association
5
Highest granted
Multi Command
1
None
Note
Home Assistant and Z-Wave JS will never return a “Working” or “Fail” status for a valid and supported command of the Supervision Command Class.

Z-Wave Terminology
This section explains some Z-Wave terms and concepts you might find in Z-Wave product documentation.
Classic Inclusion Versus SmartStart
Home Assistant supports both classic inclusion and SmartStart. Classic inclusion means you set both the hub and the device to be included into the corresponding mode. The alternative is SmartStart, where the hub is constantly listening for inclusion requests from devices that want to join the network.
SmartStart
SmartStart enabled products can be added into a Z-Wave network by scanning the Z-Wave QR Code present on the product with an adapter supporting SmartStart inclusion. No further action is required and the SmartStart product will be added automatically within 10 minutes of being switched on in the network vicinity. Not all devices support SmartStart. Some devices require classic inclusion. For documentation on adding a device to Home Assistant, refer to adding a new device to the Z-Wave network.
Terminology Mapping Table
Throughout this documentation, Home Assistant terminology is used. For some of the concepts, the terminology does not correspond to the terminology used in Z-Wave documentation. The table below provides equivalents for some of those terms.
Home Assistant
Z-Wave
Description
exclusion
remove
The process of removing a node from the Z-Wave network
inclusion
add
The process of adding a node to the Z-Wave network
multilevel switch
represented by different entity types: light, fan etc.
The process of copying
Removing Z-Wave JS from Home Assistant
This removes all paired Z-Wave devices and their entities, the Z-Wave JS app, and the Z-Wave integration from Home Assistant.
To Remove Z-Wave JS from Home Assistant
Remove the device from your Z-Wave network.

Remove the Z-Wave integration.
Go to Settings > Devices & services and select the integration card.

Next to the integration entry, select the three dots menu.

Select Delete.


If it hasn't been deleted automatically, remove the Z-Wave JS app.
Go to Settings > Apps > Z-Wave JS.

Select Uninstall.

Decide whether to also delete the data related to the app or whether to keep it.


Done. Z-Wave JS is now completely removed from your Home Assistant server.
You can now use your Z-Wave devices and adapter on a new server.


Related Topics
Other Z-Wave adapters

Help Us Improve Our Documentation
Suggest an edit to this page, or provide/view feedback for this page.

Integration Owners
This integration is being maintained by the Home Assistant project.
Categories
Binary sensor

Button

Climate

Cover

Event

Fan

Hub

Humidifier

Light

Join Us and Contribute!
GitHub repo

Developers Portal

Design Portal

Data Science Portal

Community Forum

Creator Network

Works With Home Assistant

Our community

Reporting issues

System Status
Integration Alerts

Security Alerts

System Status

Companion Apps
iOS and Apple devices

Android and Wear OS

...and more!

Support Us
Merch store

Home Assistant Cloud

Governance
Privacy Notices

Contributor License Agreement

[END OF DOCUMENT — 100 PAGES PROCESSED]
