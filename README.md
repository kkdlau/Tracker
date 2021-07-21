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
- [ ] Using `native_video_view` to support video streaming instead

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
## Data Structure of Action Sheet

```typescript
interface Action {
  description: String; // description of Action
  expect: number; // expected fnish time of Action
  diff: number; // time difference between actual finish time and expected
}

interface ActionSheet {
  description: String; // overall description of action sheet
  actions: Array<Action>; // list of Action
}
```

### Example
```json
{
  "description": "Description of the file",
  "actions": [
    {
      "description": "Description of the action",
      "expect": 10,
      "diff": -10
    },
    {
      "description": "Another action",
      "expect": 100,
      "diff": 10
    }
  ]
}
```