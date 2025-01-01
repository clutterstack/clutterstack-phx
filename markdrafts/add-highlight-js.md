---
title: Use highlight.js in a Phoenix app
kind: particle
date: 2024-12-22
keywords: 
    - elixir
    - phoenix
    - blog
    - cheatsheet
---

David Bernheisel wrote about using [highlight.js](https://highlightjs.org/) alongside Elixir's [Makeup syntax highlighter](https://github.com/elixir-makeup/makeup) in 2020. Here's what the process looked like for me when I followed along with Phoenix asset management of 2024.


<!-- sidenote -->
Guilty sidenote: Another intriguing possibility for getting highlighting for more languages without contributing to Makeup is to integrate the Golang highlighting tool [Chroma](https://github.com/alecthomas/chroma) into the Nimble Publisher process, to avoid extra JS overhead on the deployed site.
<!-- /sidenote -->


To recap the premise:

I use Nimble Publisher to convert Markdown files to HTML for this site. Nimble Publisher uses Makeup to encode highlighting information into element classes in the output HTML, and I just have to grab a Makeup-compatible CSS file for the app that renders that HTML to use.

For languages that Makeup doesn't yet cover, 

lexing: https://gist.github.com/VideoCarp/d7cec2195a7de370d850aead62fa09cd

https://highlightjs.readthedocs.io/en/latest/readme.html#using-custom-html