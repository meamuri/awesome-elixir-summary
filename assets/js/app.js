// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

let minStarsInput = document.getElementById("min_stars")

/**
 * Solution is inspired by:
 * https://stackoverflow.com/a/28838789/9072646
 */
minStarsInput
    .addEventListener("keyup", function(event) {
        event.preventDefault();
        let len = this.value.length

        if (len > 0) {
            let lastSymbol = this.value[len - 1].replace(/[^\d]/, '')
            this.value = this.value.slice(0, len - 1) + lastSymbol
        }

        if (len > 8) {
            this.value = this.value.slice(0, len - 1)
        }

        if (event.keyCode === 13) {
            let stars = parseInt(this.value)
            let url = isNaN(stars) ? "/" : "/?min_stars=" + stars
            window.location.replace(url)
        }
    });
