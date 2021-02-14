
---
title: "Hugo Themes"
linkTitle: "Hugo Themes"
weight: 2
description: >
  Some interesting Hugo themes for Web pages
---


{{% pageinfo %}}
**Learning Objectives**

* Find useful hugo themes that allow documenting projescts.
  
**Topics covered**

{{% table_of_contents %}}

{{% /pageinfo %}}

When creating Web pages often you are looking for an easy way to 
organize documentation tha is in a more structured form mthan simply 
a blog.

For this reason the following hugo themes may be useful:

## Docsy

* Docsy: <https://themes.gohugo.io/docsy/>

  * cons: no modules, needs tto switch from master to main
  * pro: nice front page, we used this a lot, this Web sit is create with it
    
  <img src="https://d33wubrfki0l68.cloudfront.net/cfb7cefc183c620cdbf616e1bca8b09aee1abb39/b14c7/docsy/screenshot-docsy_hua9135189238b9d5f65960deb21cd5534_311057_1500x1000_fill_catmullrom_top_2.png" width="50%">

## Dot

* Dot: <https://themes.gohugo.io/dot-hugo-documentation-theme/>
  
  <img src="https://d33wubrfki0l68.cloudfront.net/d61510089508655a1cf3ce68e080f32c09bfb014/78b06/dot-hugo-documentation-theme/screenshot-dot-hugo-documentation-theme_hu0e8551a7416ed52d94a3561e173a56d1_511161_1500x1000_fill_catmullrom_top_2.png" width="50%">

## Syna

* Syna <https://themes.gohugo.io/syna/>
  
  <img src="https://d33wubrfki0l68.cloudfront.net/90c81cfe58ef55239dc8ab20a7929190e37569dc/ac30a/syna/screenshot-syna_hu67f3338107d8d55d9a97ea2dda03e458_680382_1500x1000_fill_catmullrom_top_2.png" width="50%">

## Compose

* Compose: <https://themes.gohugo.io/compose/>
  
  * pro: modules, menu with dynamic location update

  <img src="https://d33wubrfki0l68.cloudfront.net/f8a2f2ef6addf153348db8048452d5e440f755f2/49de6/compose/screenshot-compose_hu99489f9807af7702310939313b1648eb_168621_1500x1000_fill_catmullrom_top_2.png" width="50%">


## Dynamic Web Site (non documentation focused)

Although not a documentation oriented Wen page, The following recieved our 
attention as it show a very dynamic look. However it could be a bit 
distracting.

So one could develop two repos. One as frontpage with a splashy theme, 
the oster tha just focusses on the documentation

* Omega: <https://themes.gohugo.io/omega-hugo-theme/>
  
  <img src="https://d33wubrfki0l68.cloudfront.net/fcf8b8fc0cd7241d92058ae1eb2ad673d6d4ee9b/9db27/omega-hugo-theme/screenshot-omega-hugo-theme_huc726808b0fa2e5c225e312aef2dbf5cb_842370_1500x1000_fill_catmullrom_top_2.png" width="50%">


## Converting Hugo to ePub

The following git repo contains documentation on how to convert hugo Web 
sites to epub

* <https://github.com/weitblick/epub>

An article in german is available at 

* <https://www.raspberrypi-spy.co.uk/wp-content/uploads/2012/11/Raspberry-Pi-Mounting-Hole-Template.pd>f

The following script stes this up for you automatically:

```bash
git clone https://github.com/weitblick/epub.git
cd epub
cd exampleSite
mkdir themes
cd themes
git clone https://github.com/weitblick/epub.git
cd epub 
rm -rf .git
rm -rf exampleSite   # remove the example site in the theme
cd ../..
hugo
bash ./deploy.sh
```