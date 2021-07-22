# Tracker

Tracker is an app which spports recording videos with timestamps.
## UI Development

### Video Recording Page
- Display selected stamp sheet
- Display recording time
- Add camera focus
- Add Zoom In / Out
- Fix video orientation
- Fix camera preview orientation 

### Video player
- Wrap all control UI into safeArea ( need to find way to hack the UI and modify the library)

### Stamp Sheet Editor:
- Support entering negative number

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
