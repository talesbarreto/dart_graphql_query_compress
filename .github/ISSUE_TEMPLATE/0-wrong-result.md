---
name: "[Wrong output] "
about: Report an invalid query being generated by this package
title: '[Wrong output] '
labels: 'wrong-output'
assignees: ''
---

### Original query
```graphql
query GetRammstein($firstTopPhotos: Int) {
    tupa(shame: " asd aferg rtohj oer wfhweufioh wieyf ") {
        caller
    }
}
```
### Current result:
```graphql
query GetRammstein($firstTopPhotos:Int){tupa(shame:"asdafergrtohjoerwfhweufiohwieyf"){caller}}
```

### Desired output:
```graphql
query GetRammstein($firstTopPhotos:Int){tupa(shame:" asd aferg rtohj oer wfhweufioh wieyf "){caller}}
```
