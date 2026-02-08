<p align="center">
  <a href="#">
    
  </a>
  <p align="center">
   <img width="150" height="150" src="https://raw.githubusercontent.com/urbi-ae/unpub-assets/edcad5132540209cf7c9562e246a62d2909d2897/balady_uikit.png" alt="Logo">
  </p>
  <h1 align="center"><b>Balady App UIKIT</b></h1>
  <p align="center">
  Optimize layoting with predefined components.
  </p>
</p>
Balady UIKit is a Flutter package designed to enhance UI development with pre-designed widgets and a dynamic color generator. It integrates with Widgetbook for visualizing widgets, facilitating a collaborative and efficient development process.
<br/>
<br/>

## Contributing
Please read our **Pull Request Guidelines** in [English](docs/pull_request_guidelines/pull_request_guidelines_en.md), [Russian](docs/pull_request_guidelines/pull_request_guidelines_ru.md) or [Arabic](docs/pull_request_guidelines/pull_request_guidelines_ar.md) before contributing to this project.

## Breaking changes and migration guides
Please read our [Breaking changes and migration guides](docs/MIGRATION.md) if you have troubles with newer versions of our package

## Features

`balady_uikit`:
- Color Generator: Automatically generates color palettes from `balady_uikit/assets/colors/colors.json`
- Widgetbook Integration: Supports Widgetbook for widget testing and visualization, deployed at GitHub Pages.


## Installation 

To add `balady_uikit` to your project, include it in your `pubspec.yaml` file:

```yaml
dependencies:
  balady_uikit: ^4.1.2
```

## Color generator
placed here - balady_uikit/lib/gen/generator/color_generator.dart
Generates base color pallets from: balady_uikit/assets/colors/colors.json
## Widgetbook
https://docs.widgetbook.io/
Instance of widgetbook should be deploying to github_pages
https://urbi-ae.github.io/baladi/
~~Will be deploying on every pullrequest
From /example/web~~

If you will use new color schemes from design team, do it before buld:
- need to replace "dynamic/" and "static/" from color scheme json it might be in colors names 
- uncomment color generator build settings - /build.yaml

* First run it from /baladi_uikit: just prebuild

* For run widgetbook instance: just run_widgetbook


## Icons as fonts
To add new icons you need to use https://icomoon.io/app for converting svg icons to ttf font.

1. Export svg from figma and save them inside your local folder.
2. Open https://icomoon.io/app/#/projects and import project file from `assets/fonts/mapness_icons/MAPNESS_ICONS.json`
3. After that import your icons to the correct set
4. Edit name class for imported icons
5. After you imported and named all icons, rearrange icons by name order.
6. Select all icons in one set at the time
7. Click generate font and download the zip file
8. Unzip the zip file into folder. Copy ttf file inside fonts folder.
9. Paste it inside `assets/fonts/mapness_icons/` and rename it and save as replacement for the corresponding category icons font.
10. You have to have a *.dart file inside this zip file. Open file and copy context (inside curly brackets) of the .dart file from unzipped file folder
11. Open the file of corresponding category icon inside `lib/core/icons/` (e.g. for `general` icons it will be `general_icons.dart`)
12. Delete everything in old one and paste all the static declared variables from unzipped *.dart file
13. Add `fontPackage: packageName` parameter for each `IconData`
14. Repeat steps from 6 to 13 for all other icon sets that was changed by you
15. Update project file by downloading it from https://icomoon.io/app/#/projects and paste it as file at `assets/fonts/mapness_icons/MAPNESS_ICONS.json`
