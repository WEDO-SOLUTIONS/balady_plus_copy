# Redesign of CHANGELOG documentation

> Inspired by Flutter GitHub [CHANGELOG.md file](https://raw.githubusercontent.com/flutter/flutter/refs/heads/master/CHANGELOG.md)

INTERNAL NOTE: PLEASE DON'T JUST PASTE ISSUE TITLES!

Make sure that the text here helps customers understand
whether they are likely to be affected by the issue,
without them needing to read each issue individually.
Our goal is to make the list easy for them to scan.

### (4.2.1)[https://github.com/urbi-ae/balady_uikit/milestone/4]
- [Avatar](https://github.com/urbi-ae/balady_uikit/pull/223)                - Fix avatar issues to fix requirements

### (4.2.0)[https://github.com/urbi-ae/balady_uikit/milestone/3]
- [Toast](https://github.com/urbi-ae/balady_uikit/pull/211)                 - Remove toast from UIKit
- [BSA-3055, BSA-3056](https://github.com/urbi-ae/balady_uikit/pull/218)    - UI kit colors opacity and spacings
- [Avatar, Loader](https://github.com/urbi-ae/balady_uikit/pull/210)        - Avatar and loader refactoring
- [Button](https://github.com/urbi-ae/balady_uikit/pull/213)                - show clear button while readonly
- [Refactoring](https://github.com/urbi-ae/balady_uikit/pull/212)           - Refactoring (breaking changes)

## Release 4.1.7 Changes
- [Icons] Add new icons to driving and transport icons
- [Icons] Add new icons to generic 16px icons
- [Counter] Update padding and font

## Release 4.1.6 Changes
- [Icons] Add new icons to driving and transport icons

## Release 4.1.5 Changes
- [SliderListView] Add dot colors to constructor

## Release 4.1.4 Changes
- [ItemActionBar] Add color scheme to constructor

## Release 4.1.3 Changes
- [Color Scheme] Saudi day color scheme

- ## Release 4.1.2 Changes
- [BottomActionBar] Fix horizontal scrolling

## Release 4.1.1 Changes
- [POIContent] **Breaking**: Removed
- [NaviRoadPanel] **Breaking**: Removed
- [Badge] Add tertiary color scheme
- [ContentRow] Fix highlight text span suggestion function
- [ContentRowExpandable] Add additional padding to the `customActionWidget`
- [StatefulBottomSheet] Add content padding field
- [StatelessBottomSheet] Add content padding field
- [StatelessBottomSheetController] - fixed opening sheet with animation then content size is changing
- [DS-Styles] Update color and text style properties
- [Counter] Added the color schemes and sizes, update to the actual design
- [Toggle] Update colors
- [Loader] Update to the actual design
- [Buttons] Depricate V2 button, saving the new properties in the main version
- [Chips] Update to the actual design
- [TopBar] Update to the actual design
- [ContentRow] Update to the actual design and Depricate V2 ContentRow, saving the new properties in the main version
- [Tabs] Update colors and text styles
- [Stories] Update colors and text styles
- [ToastMessages] Update colors and text styles
- [MapControls] Update to the actual design
- [ManeuverAndLimit] Update to the actual design
- [AppButton] Fix default constraints and inner paddings
- [AppButton] Update colors
- [ABRoutes] Update to the actual design
- [ABPoints] Update to the actual design
- [ABRoute] Fix crash in keys update
- [BottomActionBar] Fix paddings and scroll/expand behavior
- [BaladyTopBar] Add use safe area boolean
- [_TabsV2] Update to the actual design
- [ShapeShadow] Add new widget to apply shadow with a custom shape behind a child
- [CI] fix widgetbook CI builds

## Release 4.0.3 Changes
- [ABRoute] Fix crash in keys update
## Release 4.0.2 Changes
- [Content Row] Fix highlight text span suggestion function
## Release 4.0.1 Changes
- [Badge] Add tertiary color scheme 

### [4.0.0](https://github.com/urbi-ae/balady_uikit/milestone/1)
- [App] Refactoring and cleaning of unused widgets
- [App] Removed foundation colors
- [App] Removed corner_radius and numeric_base
- [Counter](https://github.com/urbi-ae/balady_uikit/pull/186)              - Make it resizable and fitted
- [RoadPanelEnabled](https://github.com/urbi-ae/balady_uikit/pull/192)     - Add Dragger to the eta
- [BSA-1884](https://github.com/urbi-ae/balady_uikit/pull/186)             - Make it resizable and fitted
- [BSA-23661](https://github.com/urbi-ae/balady_uikit/pull/192)            - Add dragger to the eta sheet
- [BSA-2126](https://github.com/urbi-ae/balady_uikit/pull/193)             - Change label and hint text size to match the figma
- [StatefulBottomSheet](https://github.com/urbi-ae/balady_uikit/pull/196)  - Add new topHeaderOffset delegate
- [StatefulBottomSheet](https://github.com/urbi-ae/balady_uikit/pull/200)  - Migrate to new delegate classes
- [StatelessBottomSheet](https://github.com/urbi-ae/balady_uikit/pull/200) - Migrate to new delegate classes
- [StatelessBottomSheet](https://github.com/urbi-ae/balady_uikit/pull/195) - Add clipped by header
- [StatelessBottomSheet](https://github.com/urbi-ae/balady_uikit/pull/195) - Add border radius delegate
- [StatelessBottomSheet](https://github.com/urbi-ae/balady_uikit/pull/195) - Add inner padding delegate
- [StatelessBottomSheet](https://github.com/urbi-ae/balady_uikit/pull/195) - Fix rebuild viewport
- [GeneralIcons](https://github.com/urbi-ae/balady_uikit/pull/198)         - Update icons
- [PlacesIcons](https://github.com/urbi-ae/balady_uikit/pull/198)          - Update icons
- [WeatherIcons](https://github.com/urbi-ae/balady_uikit/pull/198)         - Update icons
- [StopNumbersIcons](https://github.com/urbi-ae/balady_uikit/pull/198)     - Add icons

### 3.4.4
- [GeneralIcons] Update heart icons
- [SliderListView] Remove dependency on on Direction
- [SystemIcons] Add matchTextDirection in right arrow

### 3.4.3
- [NaviRoadPanel] Route panel change logic

### 3.4.2
- [StatelessBottomSheet] Add notification scroll on header,footer, topHeader
- [StatefulBottomSheet] Add notification scroll on header,footer, topHeader

### 3.4.1
- [BaladyInputConfig] Add optionals in maxLines field maxLines

### 3.4.0
- [StatelessBottomSheet] Fixed layout sliver content with height model
- [BaladyInput] Small UI twicks
- [WidgetLabel] Fixed requared indicator
- [BaladyTopBar] Changed title text style
- [Icons] Update DS icons


### 3.3.9
- [NaviRoadPanelWidget] Fix padding

### 3.3.8
- [NaviRoadPanelWidget] Fix padding

### 3.3.7
- [SliverFillAfter] Fix layout base on remaining paint extent
- [BaladyInputSupportingText] Fix the max length boundry

### 3.3.6
- [GeneralIcons] Add Offer icon

### 3.3.5
- [GeneralIcons] Add filledHeart icon
- [GeneralIcons] Add photoSolid icon
- [SystemIcons] Add avatar icon
- [SystemIcons] Add code icon
- [SystemIcons] Add parkingAdd icon
- [TransportIcons] Replace metroStation icon
- [NaviRoadPanelWidget] Fix animations
- [SliverAlignBox] Fix order of hit test

### 3.3.4
- [NaviRoadPanelWidget] Update search icon view options

### 3.3.3
- [MapControls] Change weather sun icon

### 3.3.2
- [SliverAlignBox] Fix hit test child
- [MapControls] Fix weather and map button

### 3.3.1
- [NaviRoadPanel] Add Route buttons

### 3.3.0
- [NaviRoadPanel] Add search buttons
- [SliverAlignBox] Add SliverAlignBox widget
- [StatefulBottomSheet] Fix clip and offset horizontal paddings.
- [StatefulBottomSheet] Fix sheet height and max height calculations.
- [StatefulBottomSheet] Add force multiplier.
- [StatelessBottomSheet] Fix clip and offset horizontal paddings.
- [StatelessBottomSheet] Add force multiplier.
- [NaviRoadPanelWidget] Add RenderBox to NaviRoadPanel

### 3.2.8
- [StatefulBottomSheet] Fix header clipping then scrolling.
- [StatefulBottomSheet] Fix clipping height animation.
- [StatefulBottomSheet] Fix behavior setup offsets then components changed size.
- [StatefulBottomSheet] Fix behavior setup offsets then clipping offset changes.
- [StatefulBottomSheet] Fix behavior setup reacts to resizing sheet.
- [StatefulBottomSheet] Fix janky frame then the components inside sheet is updated.
- [StatefulBottomSheet] Fix clip and offset horizontal paddings.
- [StatefulBottomSheet] Add safeMaxOffset in behaviors to support better clipping.
- [StatefulBottomSheet] Add physics argument.
- [StatefulBottomSheet] Add tests for edge cases.
- [StatelessBottomSheet] Fix header clipping then scrolling.
- [StatelessBottomSheet] Fix clip and offset horizontal paddings.
- [StatelessBottomSheet] Add physics argument.
- [FeedbackConfirmationIndicator] Trigger confetti on init.

### 3.2.7
- [General32Icons] Fix athkarAction icon

### 3.2.6 
- [Icons] Add new icons for quran and athkar

### 3.2.5
- [Colors] Actualize color according to the Design System
- [ContentRow] Change splash on opacity during the tap
- [Icons] Return text directions for icons

### 3.2.4
- [StatefulBottomSheet] Fix header clipping then scrolling.
- [StatefulBottomSheet] Add color argument for dragger.
- [StatefulBottomSheet] Add offset snapping moder.
- [StatelessBottomSheet] Add top header widget.
- [SymmetricExpandableList] Little refactor and typo fixes.
- [SystemIcons] Add warning icon.
- [PoiContent] Redesign component.
- [SliverFillAfter] New component to fill viewport with the child doesn't.

### 3.2.3
- [StatefulBottomSheet] Fix wrong offset calculation on resize.
- [StatefulBottomSheetController] Add main and initial animation `Curves`
- [StatefulBottomSheet] Add new test cases.
- [StatelessBottomSheet] Fix wrong offset calculation on resize.
- [StatelessBottomSheet] Add new test cases.

### 3.2.2
- [Slider] Add new component Slider
- [BottomActionBar] Shadow now could be disabled by the constructor parameter.
- [Input] Don't crop the text in the long text for deprecated input 
- [Input] Huge refactoring of the input field and its interface
- [Chips] Update colors for new palette
- [Input] Fix input truncation set state on dispose
- [Input] Improved UI for disabled state of input

### 3.2.1
- [Icons] Update General icons
- [Icons] Update General 16 icons
- [Icons] Update Places icons
- [Icons] Update System icons
- [Icons] Update Social icons
- [Icons] Update Transport icons

### 3.2.0
- [Icons] Update General icons
- [Icons] Update General 16 icons
- [Icons] Update General 32 icons
- [Icons] Update Transport icons
- [Icons] Add Places 16 icons
- [Icons] Update Places icons
- [StatefulBottomSheet] Introduced MultiSnappingBehavior to support multiple snapping models, enhancing snapping flexibility.
- [StatefulBottomSheet] Add ComponentsSnappingBehavior and its associated SnapComponent variations, allowing fine-grained control over bottom sheet snapping positions based on components like headers, footers, and content.
- [StatefulBottomSheet] Add a delegate to dynamically control the opacity of the outside widget based on state, interpolation, and aspect ratio.
- [StatefulBottomSheet] Introduced support for resizing the bottom sheet to avoid on-screen keyboard padding, improving UX for text inputs.
- [StatefulBottomSheet] Refactored Behaviors: Consolidated snapping behaviors into a unified structure with a base class, simplifying the implementation and enabling code reuse.
- [StatefulBottomSheet] Improved Safe Area Handling: Fixed safe area boundary issues to ensure proper padding and layout alignment, particularly in scenarios with navigation bars or bottom insets.
- [StatefulBottomSheet] Fixed Keyboard Appearance Issues: Resolved problems where the bottom sheet height and view insets were incorrectly calculated when the keyboard appeared.
- [StatefulBottomSheet] Performance Improvements: Reduced unnecessary rebuilds and draw calls by optimizing render logic.
- [StatefulBottomSheet] Improved layout and rendering efficiency
- [StatelessBottomSheet] Safe Area Boundary Box: Fixed incorrect rendering of content and background within the safe area, ensuring proper alignment across all devices.
- [StatelessBottomSheet] Fixed Keyboard Appearance Issues: Resolved problems where the bottom sheet height and view insets were incorrectly calculated when the keyboard appeared.
- [StatelessBottomSheet] Performance Improvements: Reduced unnecessary rebuilds and draw calls by optimizing render logic.
- [StatelessBottomSheet] Add a delegate to dynamically control the opacity of the outside widget based on state, interpolation, and aspect ratio.
- [SnappingSimulation] Improve recognition of the end of the scrolling animation.
- [Design system] Updated color palette of the app

### 3.1.2
- [Input] Add stateKey to the widget

### 3.1.1
- [StatelessBottomSheet] Fix components auto resize

### 3.1.0
- [StatelessBottomSheet] Add resize content to avoid bottom padding
- [StatelessBottomSheet] New options to build the bottom sheet for the first frame
- [StatelessBottomSheetController] New property isClosed
- [StatelessBottomSheetController] Fix onClose method trigger then sheet is building
- [ContentRow] Fix ContentRow height

### 3.0.8
- [Chips] fix shadow radius

#### 3.0.7
- [StatefulBottomSheet] Fix parameters not provided to render object

#### 3.0.6
- [StatefulBottomSheet] Add `outside` property to draw widget which take all available space outside the bottom sheet
- [StatelessBottomSheet] Add `outside` property to draw widget which take all available space outside the bottom sheet
- [StatelessBottomSheet] Add `isInteractive` property which defines can the bottom sheet be collapsed by gestures
- [StatelessBottomSheet] Fix snapping to close a bottom sheet on the distance based
- [StatelessBottomSheet] `onClose` callback property now provides a controller 
- [StatelessBottomSheet] Now is reacting to content size changes.

#### 3.0.5
- [StatefulBottomSheet] Fix initial layout position then sheets opens without animation
- [StatefulBottomSheet] Fix offset property for top header not provided to render object
- [StatefulBottomSheet] Content widget list is not longer required
- [PoiContentAboutWidget] Fix constant repainting

#### 3.0.4
- [StatefulBottomSheet] Fix notifications then top header height changed
- [StatefulBottomSheet] Fix opening sheet without animations
- [StatefulBottomSheet] Improve performance by limiting the number of layouts triggers
- [StatefulBottomSheet] Added offset property for top header

#### 3.0.3
- [Input] fix always disposed controller

#### 3.0.2
- [StatefulBottomSheet] Notify listeners then top header height changed outside of sheet height change.

#### 3.0.1
- [StatefulBottomSheet] Fixed wrong snapping at scrolling
- [StatefulBottomSheet] Fixed wrong sheet height received from the controller

#### 3.0.0
- [StatelessBottomSheet] NEW stateless bottom sheet
- [StatefulBottomSheet] Support for bottom save area
- [StatefulBottomSheet] Fixed opening sheet without animation
- [StatefulBottomSheet] Improve snapping simulation
- [ContentRow] Added v2 interface of Content Row and changed UI of it
- [ABRoute] Improvements in design ABRoute Component
- [Input] fix height contraints on error state

### 2.0.22
- [Chips] Chips padding and text alignment

### 2.0.21
- [Chips] Changed the chips and its interface. Now we use [ChipsElement]
- [Input] Actualize design of the input according to the Figma
- [Icons] Update System icons
- [Button] Add new version of the button
- [Search] Improve search

### 2.0.20
- [Icons] - fix route icon

### 2.0.19
- [BaladyInput] - fix constraints
- [BaladyInput] - remove counter text

### 2.0.18
- [BaladyInput] - replace suffixIcon with suffix

### 2.0.17
- [StatefulBottomSheetController] Disable ignoring header for animations on controller detach 

### 2.0.16
- [Icons] - added new icons


### 2.0.15
- [StatefulBottomSheet] Added support for dynamic resizing
- [StatefulBottomSheet] Fixed bugs with bottom sheet open animations
- [StatefulBottomSheet] Added gesture active boundary box
- [StatefulBottomSheet] Refactor and improve performance

### 2.0.14
- [LimitAlert] - Hide speed limit for free roam

### 2.0.13
- [StatefulBottomSheet] Rename [AppBottomSheet] to [StatefulBottomSheet] to better reflect the widget's purpose and prepares to and to prepare the logic chain for adding [StatelessBottomSheet]
- [StatefulBottomSheet] Fixed bugs with bottom sheet animations and snapping
- [StatefulBottomSheet] Refactor and improve performance

### 2.0.12
- [BottomSheet] Component sizes is no longer a notifier

### 2.0.11
- [BottomSheet] Controller dispose and attach animation fixes
- [BottomSheet] Add support to ignore height shrinking

### 2.0.10
- [TopBar] Support to update top bar on action model change

### 2.0.9
- [BottomSheet] Small bug fixes

### 2.0.8
- [Icons] Add matchDirection for arrow icons

### 2.0.7
- [Stories] Change style tokens in story widget
- [Icons] Update bookmark icons
- [ContentRow] New title builders
- [SegmentsButton] Add new component
- [ContentColumn] Add new component
- [Loading] Fix code style and update component
- [TabsV2] Add new parameters for tabs and tabs_row
- [AssetsGen] Add new icon - roadCameras

### 2.0.6
- [Icons] Fix icons and import new icons

### 2.0.5
- [TrafficControl] Expose border radius

### 2.0.4
- [POIContent] Add feedback section
- [Icons] Update general icons
- [AppBar] Add disabled color

### 2.0.3
- [BottomSheet] Improve performance and animations
- [BottomSheet] Refactor controller public properties
- [BottomSheet] Add background fill delegate to render box

### 2.0.2
- [ABRoute] Fix reorderable list behavior on reorder

### 2.0.1
- [BottomSheet] Add new BottomSheet fixed size behavior
- [BottomSheet] Add new BottomSheet no snapping behavior
- [BottomSheet] fix BottomSheet scrolling physics

### 2.0.0
- [BottomSheet] Add new BottomSheet component
- [Search] Search updated to v2 from 09.07

### 1.4.10
- [BottomActionBar] Add padding to home indicator
- [POI] Fix for phone and license text direction

### 1.4.9
- [AppButtons] Delete Flexible

### 1.4.8
- [Search] Update search component  

### 1.4.7
- [AppIcons] Hotfix for packageName

### 1.4.6
- [POI] Hotfix for Parking in POI Content

### 1.4.5
- [AppButton] Add color parameter to AppButton

### 1.4.4
- [Shadows] Add new shadows schemes from design 3.0

### 1.4.2
- [TabsV2] Add tabs in version 2
- [POI] Change background color of the [ContentWrapper]
- [POI] Fix POI Content visual inaccuracies

### 1.4.1
- [Icons] Import new system icons
- [Icons] Fix general route icon

### 1.4.0
- [TopBAr] Add SystemUiOverlayStyle

### 1.3.9
- [ContentRow] Add bool support title RTL field

### 1.3.8
- [Icons] Import new general icons
- [Icons] Reimport some of the icons

### 1.3.7
- [Icons] Import new system icons

### 1.3.6
- [Icons] Import new general

### 1.3.5
- [Fonts] Add Fonts arabic in textStyle v3

### 1.3.4
- [Icons] Reimport some system icons
- [Layout] Export new RadiusBorder constants

### 1.3.3
- [Icons] Import new general and system icons

### 1.3.2
- [ContentRow] Add MarkedUpTextSpan to highlight text in Content Row 
- [Typography] Add new fonts and text styles
- [Colors] Add new color scheme as colorSchemeV2

### 1.3.1
- [Icons] Import `ellipsis`, `circleNull` and `twitter` icons

### 1.3.0
- [Picture] - Added network image caching support
- [Icons] Import new project icons
- [BaladyInput] Add default [TextInputAction] search for search factory

### 1.2.4
- [Navi Road Panel] Finished the element pixel perfect

### 1.2.3
- [Maneuver] Delete force text height for speed limit
- [Package] Remove dependency on Google Fonts in pubspec.yaml

### 1.2.2
- [Stories]: Update loading color and add stroke
- [NaviRoadPanel] fix height of panel according to design
- [Typography] add package name to text styles
- [Input] Fix empty array error in input

### 1.2.1
- BALADY-210: Add [ConfettiAnimation] component
- BALADY-210: Add [FeedbackConfirmationIndicator] component
- [NaviRoadPanel] fix text overflow and refactoring
- BALADY-273: [LayersOnTheMap] Made the action text clickable for Layers feature
- BALADY-433: [ABRoad] Separated and changed components

### 1.0.0
- BALADY-1494: poi header
- BALADY-1497: map controls
- BALADY-1566: Add [AppNavigationBar] component
- BALADY-1501: Add [NaviRoadPanel] component
- BALADY-1499: Add [ABViewController],[RoadClosures] components
- BALADY-1491: Add [BottomActionBar] components
- BALADY-1565: Add [Checkbox] components
- BALADY-1563: Add [Toggle] components
- BALADY-1480: Add [Picture] components
- BALADY-1479: Add [Counter] components
