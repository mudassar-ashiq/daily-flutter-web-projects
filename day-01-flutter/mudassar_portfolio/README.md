# My Portfolio — Flutter Web

Day 1 of my daily project series.

This is my personal portfolio website, made with Flutter and Dart.
It has a short intro, an about section, my skills, and the two
projects I have worked on so far (MoneyGods Transport and ShopEase).
There is also a link to my GitHub at the top and in the footer.

## What is in it

- Header with links that scroll to each section
- Intro section with my name, what I study, and where I am from
- Skills shown in a grid — it changes from 5 columns on a big
  screen to 2 columns on a phone
- Project cards with what each app does and the tools I used
- The layout is responsive. On wide screens things sit side by
  side, on narrow screens they stack in one column

I used my usual colours for this one: navy (#0A1F44) and green
(#1E7A46), with Material 3.

## Run it

```
flutter pub get
flutter run -d chrome
```

For a release build:

```
flutter build web --release
```

The output goes to `build/web/`.

## Tests

```
flutter analyze
flutter test
```

The tests check the screen-size breakpoints and that the page
renders my name and the projects section on both desktop and
mobile widths.

## What I practised

- Making a layout that changes with screen width (LayoutBuilder)
- Splitting the code into separate files for theme, data and
  sections instead of putting everything in main.dart
- Writing a few widget tests and fixing the overflow errors
  they found in the skills grid
- Opening an outside link (my GitHub) with url_launcher
