# Tracker

Tracker is an app which spports recording videos with timestamps.
## UI Development
### Main Page

- [X] Video recording
- [ ] Different recording modes
- [x] Different camera cofiguration
- [x] Select different action sheets
- [x] Generate Video thumbnail (https://pub.dev/packages/video_thumbnail) 

### Video Player

- [x] Pause / Play
- [x] Go backward / forward
- [x] Text overlay
- [x] Share text recording

### Action Sheet Editor

- [x] Add / Remove actions
- [x] Time Picker
- [ ] Comparsion between different sheets

## Back-end Development

### Camera

- [ ] Support Zoom
- [ ] Support Focus
- [ ] Flash Light (Currently not supported because of bugs)
- [X] Camera Switching
### Video editing

- [ ] Support embedded Text Overlay

### Local Storage

- [X] Library for managing in-app videos and action sheets

### Action Sheet

* Support export action sheet into different format
  - [x] `Splitty` / `JSON`
  - [x] `.rst`
  - [x] `pure text message` (for sharing)

### New Features

 - [ ] Import Action Sheet from clipboard
## JSON Structure

```json
{
  "description": "Description of the file",
  "actions": [
    {
      "description": "Description of the action",
      "expect": 10, // Expected time, in milliseconds
      "diff": -10 // Time difference between completed time and expected time, in milliseconds
    },
    {
      "description": "Another action",
      "expect": 100,
      "diff": 10
    }
  ]
}
```