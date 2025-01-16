English | [中文](README_ZH.md)

# FALA
the world of subscriptions, is easy to use!

---

## Project Information

Fala is an open source custom subscription tool designed to help users easily manage and view the data they care about . Through easy-to-use features and cross-platform support , Fala subscription experience to a whole new level .

---

### Core Features

#### Customized Subscription Management
- Users can quickly add a subscription source by entering a link or scanning a QR code.
- Support multiple data sources to meet different scenarios.

#### Desktop Widget
- Support adding subscription data directly to desktop widgets.
- You can quickly view the data you care about at a glance through the widget.
- Support to set the subscription source according to the size of the widget.

#### Subscription Sharing
- Support to share the subscription source link, which is convenient to share the content with others.
- Sharing methods include copying the link directly or generating a QR code.

#### Subscription Update Settings
- Support user-defined subscription update interval.
- Flexible update frequency ensures that data is kept up-to-date while saving resources.

#### Subscription Management Features
- **Sort by dragging**: Users can drag the items in the subscription list to customize the sorting order to meet personalized needs.
- **Hide Subscriptions**: Subscriptions can be hidden from the main interface to avoid disturbing the view.
- **Remove Subscriptions**: Support completely removing subscriptions that are no longer needed.
### Cloud Sync
- Synchronize subscription data between Apple devices via iCloud.
- Users can seamlessly switch between iPhone, iPad, Mac and other devices, and the subscription data is always the same.
--- - - - - - - - - - - - - - - - - - - - -

### Guidelines

#### Add Subscription
- Open the Fala app and click “Add Subscription”.
- Select any of the following ways to add a subscription:
- **Scan QR code**: Quickly get the subscription source information through the built-in scanning function.
- **Manually enter**: directly enter the subscription link and click confirm to add it.

#### Viewing and Managing Subscriptions
- The subscription content will be displayed in a list, and users can view it by clicking into the detail page.
- The following management functions are provided:
- **Drag to sort**: long press the subscription item and drag it to the target position to complete the sorting.
- **Hide Subscription**: Left slide the subscription item to select “Hide” in the right menu, the subscription will disappear from the main interface, but can still be viewed and restored in the hidden subscription list.
- **Delete Subscription**: Left slide the subscription link in the subscription management on the right menu and select “Delete”, the subscription will be permanently deleted on your device, and all subscriptions under the same subscription link will also be deleted

#### Desktop Widget
- Long press on your phone's desktop to add a widget for Fala.
- Select the subscription you want to display and view the data directly on your desktop.
- Widgets are available in small, medium and large sizes.

#### Share Subscription
- In the subscription management page, select the subscription link you want to share in the long run, and choose to copy the link or generate a QR code.
- Support selecting multiple links to share together
- Share the QR code or link to your friends so that they can quickly add this subscription source.

#### Setting Subscription Update Interval
- Swipe left to select “Settings” in the menu to the right of the subscription item.

#### Enable iCloud Sync
- Turn on **iCloud Sync** on the **About Fala** page.
- When you sign in to your Apple ID, your subscription data is automatically uploaded to iCloud and synchronized to other devices.
- Users can view and manage synchronized data on any Apple device.

---

### Technical implementation

#### UI
- Use Flutter's ReorderableListView to implement the drag-and-drop sorting function, providing a smooth interactive experience.
- Add iCloud Sync switch to allow users to easily enable or disable the sync function.

#### Logic
- Use Provider to manage subscription data state and integrate with iCloud data synchronization logic.
- Synchronize with iCloud in real time after each subscription data modification, and listen for iCloud data updates to refresh the interface in time.

#### Data
- **Local storage**: use **shared_preferences** to save subscription data as local cache.
- **Cloud storage**: use Apple's CloudKit to realize iCloud synchronization function.

---

### Development progress

| Features                        | Status               | Notes                                     | 
|---------------------------------|----------------------|-------------------------------------------|
| Add Subscription (Link/QR Code) | ✅ Completed          |                                           |
| Desktop Widget Support          | ✅ Completed          | Supported on Android and iOS              |
| Share Subscription              | ✅ Completed          | Copy Link and Generate QR Code            |
| Update Interval Settings        | ✅ Completed          | Multiple Intervals Supported              |
| Drag Sorting                    | ✅ Completed          |  Use ReorderableListView                |
| Hide Subscription               | ✅ Completed          | Support to restore hidden subscription |
| Delete Subscription | ✅ Completed          |
| iCloud Sync | ✅ Completed          | Sync based on CloudKit  |
| Performance Optimization        | 🔄 Under Development | Continuously optimizing web request logic | 

---

### Data format

#### Subscription Data Format
| field name | type | description |
|---------|----------|-------|
| title | string | subscription title
| sources | []object | subscription data source

#### Subscription Source Format
| field name | type | description |
|---------|----------|------------------------------------------------|
| data_type | string | Returned data type \[ text \| html \| image \| markdown \] 
| url | string | subscription source address                                          
| type | string | location type \[ content \| preview \| widget_small \| widget_middle \| widget_large \]                           

#### Location Type Description
| type | description |
|----|--------|
| content| detail page |
| preview| subscription item preview |
| widget_small| widgets |
| | widget_middle| medium| widget | | widget_large| large| widget
| widget_large| large| widgets

#### Data Examples
```json
[
	{
		"title": "K Line",
		"sources": [
			{
				"data_type": "html",
				"url": "http://xx.com/subscription/kline_content.html",
				"type": "content",
				"proxy": "PROXY 192.168.15.32:10021"
			},
			{
				"data_type": "image",
				"url": "http://xx.com/subscription/kline.png",
				"type": "preview"
			},
			{
				"data_type": "image",
				"url": "http://xx.com/subscription/kline_2_2.png",
				"type": "widget_small"
			},
			{
				"data_type": "text",
				"url": "http://xx.com/subscription/kline_4_2.txt",
				"type": "widget_middle"
			}
		]
	}
]
```

#### server output
```js
let json = JSON.stringify([
	{...},
	...
]);
res.send(Buffer.from(json).toString('base64'));
```

---

### User experience enhancement points
- **Real-time saving of drag-and-drop sorting**: Immediately save to local storage and sync to iCloud after subscription order adjustment.

---

### Future plans
- Add subscription content categorization management function (e.g. news, blogs, social media, etc.).
- Support keyword filtering and quick search for subscribed content.
- Add desktop platform support, such as macOS and Windows, and support iCloud synchronization.
- Provide notification alerts to push out important subscription updates in time.