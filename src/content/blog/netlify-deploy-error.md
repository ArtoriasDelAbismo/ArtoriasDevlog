---
author: Jeromino
pubDatetime: 2024-10-07T09:10:00Z
modDatetime: 2024-10-07T09:10:00Z
title: Netlify deploy error
slug: netlify-deploy-error
featured: true
draft: false
tags:
  - debug
  - netlify

description:
  Netlify app builds locally but fails on deploy
---



# Struggling with Netlify Deployment? You’re Not Alone.
Are you struggling with deploying your app on Netlify? Trust me, I've been there too. Everything was running smoothly on my site until I decided to update a simple .jpg file. After pushing the changes to production, I noticed that the site wasn’t reflecting my updates. Checking Netlify revealed a deploy failure with an error message that looked something like this:

```bash
7:39:02 AM: Failed to compile.
7:39:02 AM:
7:39:02 AM: Module not found: Error: Can't resolve '../../Images/pixelMe.png' in '/opt/build/repo/src/components/HeroSection'
7:39:02 AM: ​
7:39:02 AM: "build.command" failed
7:39:02 AM: ────────────────────────────────────────────────────────────────
7:39:02 AM:   Error message
7:39:02 AM:   Command failed with exit code 1: npm run build (https://ntl.fyi/exit-code-1)
7:39:03 AM: Failed during stage 'building site': Build script returned non-zero exit code: 2 (https://ntl.fyi/exit-code-2)
7:39:03 AM: Failing build: Failed to build site
7:39:03 AM: Finished processing build request in 36.843s
```
What Went Wrong?
The error seemed odd:

```bash
7:39:02 AM: Module not found: Error: Can't resolve '../../Images/pixelMe.jpg' in '/opt/build/repo/src/components/HeroSection'
```
Everything was imported correctly, and the file path looked right, but the deploy still failed. My first guess was that it had something to do with the file extension. Initially, the image was a .jpg, so I switched it back to see if that would fix things, but the deploy continued to fail.

## Time for Some Googling
After searching online, I found several discussions about similar problems. Thankfully, [Netlify's support](https://answers.netlify.com/t/support-guide-netlify-app-builds-locally-but-fails-on-deploy-case-sensitivity/10754) guides clarified what was going on.

## Case Sensitivity Strikes Again
Turns out, filenames and paths are case-sensitive on Netlify’s servers, which means an image file named ``pixelMe.jpg`` is different from ``pixelme.jpg`` or ``PixelMe.jpg``. In my local development environment, this discrepancy might have been ignored, but when Netlify deployed the site, it couldn’t find the file due to the name being in camelcase. Changed the name of the file from ``pixelMe.jpg`` to ``pixelme.jpg`` and ta dah! Site deployed succesfully.

## Why Does This Happen?
If you work on Windows or OSX (mac), you are working on a ``case-insensitive`` system. The file system used in Netlify builds is case sensitive, while your local environment is not. Unfortunately, the error messages that result may not clearly indicate this!

Meaning: if your code includes a file or reference to a file like ``jQuery/jquery.js`` — the Netlify build may fail due to the mixed case filename. This issue can be present with ANY file that is an important part of your project, including, but not limited to:

- entry-point application files like App.js or Main.js (not the same as app.js or main.js)
- partials, modules, imports, templates
- dependencies, packages
- font files
- image, css and json files
- netlify.toml, _redirects, package.json, Gemfile or any other config or settings files
- …anything!

<Hr />

Next time you’re deploying to Netlify and things aren’t working as expected, remember: always check your paths for case sensitivity! This issue is more common than you’d think, and it can save you hours of frustration.




