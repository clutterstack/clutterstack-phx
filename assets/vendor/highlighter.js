/**
Copied then adapted from David Bernheisel's 2020 post
https://bernheisel.com/blog/moving-blog
*/

// import hljs from './highlight.js/lib/core';
import hljs from './highlight.js/lib/core';

// Import the languages you want
import elixir from './highlight.js/lib/languages/elixir';
import javascript from './highlight.js/lib/languages/javascript';
import shell from './highlight.js/lib/languages/shell';
import bash from './highlight.js/lib/languages/bash';
import erb from './highlight.js/lib/languages/erb';
import ruby from './highlight.js/lib/languages/ruby';
import yaml from './highlight.js/lib/languages/yaml';
import json from './highlight.js/lib/languages/json';
import diff from './highlight.js/lib/languages/diff';
import xml from './highlight.js/lib/languages/xml';


// And register the languages we imported
hljs.registerLanguage('javascript', javascript);
hljs.registerLanguage('shell', shell);
hljs.registerLanguage('bash', bash);
hljs.registerLanguage('elixir', elixir);
hljs.registerLanguage('eex', erb);
hljs.registerLanguage('ruby', ruby);
hljs.registerLanguage('yaml', yaml);
hljs.registerLanguage('json', json);
hljs.registerLanguage('diff', diff);
hljs.registerLanguage('html', xml);

  function highlightNotMakeup(where = document) {
    // Custom function using hljs.highlight() because
    // hljs.highlightElement() and hljs.highlightAll()
    // do stuff to the background and spacing.

    // highlightjs does have elixir but doesn't have heex
    // I'll use makeup for elixir and heex, so don't highlight
    // anything that has makeup in the class name
    where.querySelectorAll('pre code').forEach((el) => {
      if (!el.classList.contains('makeup')) {
        const lang = el.getAttribute("class")
        console.log("Got a lang: " + lang)
        if (lang != null) {
          const { value: value } = hljs.default.highlight(el.innerText, {language: lang, ignoreIllegals: true});
          el.innerHTML = value;
        }
      }
    });
  }
    // Export both the function and the initial call
export default {highlightNotMakeup};

