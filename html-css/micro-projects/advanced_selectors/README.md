## CSS Advanced Selectors Exercise

Download this [skeleton][skeleton]. Update advanced_selectors.css to practice styling more elements with advanced selectors.

[skeleton]: https://github.com/appacademy/curriculum/blob/master/html-css/micro-projects/advanced_selectors/skeleton.zip

1. Set the `cursor:pointer` and `outline:none` properties for all radio buttons, select elements, and submit buttons.
2. Style the `background-color` of the submit button gold using the `last-child` selector and give it a darkening hover effect.
3. Color every other list element in the directions list with a light-grey background.
4. Use the `+` operator to select the first review immediately after the Reviews header element and give it a 1px, solid, black, top border (Hint: the class for a submitted review will be `.user_review`).
5. Style the radio buttons with stars! Use the `stars.png` file in the assets folder. You will need to use the [WebKit extension](https://developer.mozilla.org/en-US/docs/Web/CSS/WebKit_Extensions) property `-webkit-appearance: none;`.
6. The stars will be blue when hovered and will be yellow when checked. Use the `:hover` and `:checked` pseudo-classes to change the `background-position` property of the radio buttons (Hint: You want to move the background image to show a different part of the `stars.png` image).

Compare your recipe page to [this example](https://github.com/appacademy/curriculum/blob/master/html-css/micro-projects/advanced_selectors/solution/example.html) and [this stylesheet](https://github.com/appacademy/curriculum/blob/master/html-css/micro-projects/advanced_selectors/solution/assets/advanced_selectors.css).
