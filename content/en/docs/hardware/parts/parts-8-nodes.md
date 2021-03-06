---
title: "Parts for a 8 node cluster"
linkTitle: "8 Nodes"
weight: 30
date: 2021-02-14
description: >
  A collection of parts to build Pi Clusters with 3 nodes.
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---


{{% pageinfo %}}
We list tu build a 8 node cluster with PI4 8GB

{{< table_of_contents >}}

{{% /pageinfo %}}

# Parts

This section will have the list of tools and parts that we recommend you get to assemble a PI cluster

Prices are in dollar as found at the time on online retailers.

To add parts please visit the yaml file and add them to the 
[parts list](https://github.com/cloudmesh/pi/blob/main/parts/README-parts-3.yml)

<!-- parts list is generted with bin/parts.py do creat your own parts list first-->

<!--PARTS-->

|    | vendor   | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | included   | price   | count   | total    | comment                                                                                                                                                                                                                                                                                                                                 | image                                                                              |
|---:|:---------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|:--------|:--------|:---------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------|
|  0 | Cana Kit | [Raspberry Pi 4 8GBSKU: PI4-8GB](https://www.canakit.com/raspberry-pi-4-8gb.html?defpid=4630)                                                                                                                                                                                                                                                                                                                                                                                                                                 | 1          | 75.0    | 8       | 600.0    |                                                                                                                                                                                                                                                                                                                                         | ![](https://images-na.ssl-images-amazon.com/images/I/71XIid%2BfQIL._AC_UL115_.jpg) |
|  1 | Amazon   | [Heat Sinks](https://www.amazon.com/dp/B082RT8CMS/ref=sspa_dk_detail_1?psc=1&pd_rd_i=B082RT8CMS&pd_rd_w=3exm1&pf_rd_p=7d37a48b-2b1a-4373-8c1a-bdcc5da66be9&pd_rd_wg=X8rdX&pf_rd_r=QJYGCRZD3HBP38TH3VZK&pd_rd_r=52cc97b3-1cf0-4402-ba98-0b7d8d5f8649&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUFUNzNXRU1BTFk3OUsmZW5jcnlwdGVkSWQ9QTA1NTE5NzEyME1EUFk4QVAxMTMmZW5jcnlwdGVkQWRJZD1BMDc2NDQ1MDNLTVhaWE5US0xEMUMmd2lkZ2V0TmFtZT1zcF9kZXRhaWwmYWN0aW9uPWNsaWNrUmVkaXJlY3QmZG9Ob3RMb2dDbGljaz10cnVl)                                            | 12         | 12.99   | 1       | 12.99    |                                                                                                                                                                                                                                                                                                                                         | ![](https://images-na.ssl-images-amazon.com/images/I/71falXitXBL._AC_UL115_.jpg)   |
|  2 | Amazon   | [SD Card 64GB EVO Select](https://www.amazon.com/SAMSUNG-Select-microSDXC-Adapter-MB-ME64HA/dp/B08879MG33/ref=sr_1_2?dchild=1&keywords=sd+cards&qid=1604598396&refinements=p_n_feature_two_browse-bin%3A6518305011%2Cp_89%3APNY%7CSAMSUNG%7CSanDisk&rnid=2528832011&s=pc&sr=1-2)                                                                                                                                                                                                                                              | 1          | 9.99    | 8       | 79.92    |                                                                                                                                                                                                                                                                                                                                         | ![](https://images-na.ssl-images-amazon.com/images/I/81T-dh3PhUL._AC_UL115_.jpg)   |
|  3 | Amazon   | [SanDisk 32GB Ultra microSDHC](https://www.amazon.com/SanDisk-Ultra-microSDXC-Memory-Adapter/dp/B073JWXGNT/ref=sr_1_4?keywords=32+GB+sd+card&qid=1579096243&sr=8-4)                                                                                                                                                                                                                                                                                                                                                           | 1          | 10.99   | 8       | 87.92    | Only buy those for PI3B+, for 4 use the cheaper afaster and bigger 64GB cards                                                                                                                                                                                                                                                           | ![](https://images-na.ssl-images-amazon.com/images/I/61wtfkbzUIL._AC_UL115_.jpg)   |
|  4 | Amazon   | [Duo SD Card Reader](https://www.amazon.com/dp/B07VB6C3QJ/ref=twister_B07VFBX16H?_encoding=UTF8&psc=1)                                                                                                                                                                                                                                                                                                                                                                                                                        | 1          | 7.99    | 1       | 7.99     |                                                                                                                                                                                                                                                                                                                                         | ![](https://images-na.ssl-images-amazon.com/images/I/51EWYgXoZ8L._AC_UL115_.jpg)   |
|  5 | Amazon   | [USB Charger 10-Port 120W](https://www.amazon.com/gp/product/B071KBT4ZR/ref=ppx_yo_dt_b_asin_title_o03_s00?ie=UTF8&psc=1)                                                                                                                                                                                                                                                                                                                                                                                                     | 1          | 39.99   | 1       | 39.99    | Warning when using the power switsh listed in the table, you must always switch it on and off from the build in switch. Never put the power supply on a power strip that has its own switch and use that switch to switch on and off via the power supply and leave the switch on the supply just open. THis coudl destroy your supply. | ![](https://images-na.ssl-images-amazon.com/images/I/61tZznbrI4L._AC_UL115_.jpg)   |
|  6 | Amazon   | [Cable with switch](https://www.amazon.com/Pastall-Raspberry-Switch-Type-C-2-Pack/dp/B082QQ962S/ref=pd_sbs_7?pd_rd_w=8sVVp&pf_rd_p=c52600a3-624a-4791-b4c4-3b112e19fbbc&pf_rd_r=FFBWW6TVCZGS95XD0YFG&pd_rd_r=53877786-173e-4651-9193-7a741733df5f&pd_rd_wg=YdxRj&pd_rd_i=B082QQ962S&psc=1)                                                                                                                                                                                                                                    | 2          | 8.89    | 4       | 35.56    | has 2 cables included and as the 3 cable option is not available making tis a good option                                                                                                                                                                                                                                               | ![](https://images-na.ssl-images-amazon.com/images/I/51wbUxd2X3L._AC_UL115_.jpg)   |
|  7 | Amazon   | [CanaKit Raspberry Pi 4 Micro HDMI Cable - 6 Feet (Pack of 2)](https://www.amazon.com/CanaKit-Raspberry-Micro-HDMI-Cable/dp/B07TTKD38N/ref=sr_1_1?dchild=1&keywords=CanaKit+Premium+Raspberry+Pi+4+Micro+HDMI+Cable+-+6+Feet&qid=1613164997&s=instant-video&sr=1-1)                                                                                                                                                                                                                                                           | 2          | 9.99    | 1       | 9.99     |                                                                                                                                                                                                                                                                                                                                         | ![](https://images-na.ssl-images-amazon.com/images/I/51yE14NxDLL._AC_UL115_.jpg)   |
|  8 | Amazon   | [TP-Link 8 Port Gigabit Ethernet Network Switch](https://www.amazon.com/Ethernet-Splitter-Optimization-Unmanaged-TL-SG108/dp/B00A121WN6/ref=sxin_0_ac_d_pm?ac_md=1-0-VW5kZXIgJDI1-ac_d_pm&crid=24HQ4WYMS87EK&cv_ct_cx=network+switch+8+port+gigabit&keywords=network+switch+8+port+gigabit&pd_rd_i=B00A121WN6&pd_rd_r=ca9eca7c-5023-40a5-96de-63e0d33307ec&pd_rd_w=7KFIO&pd_rd_wg=Me9bz&pf_rd_p=ef07af27-e48f-451d-ab63-8b6b216a0bc3&pf_rd_r=9TJZ9PHMZF52FTYN9PNX&psc=1&qid=1579098368&sprefix=network+switch%5C%2Caps%2C150) | 1          | 19.99   | 1       | 19.99    |                                                                                                                                                                                                                                                                                                                                         | ![](https://images-na.ssl-images-amazon.com/images/I/71%2BbqPCPpIL._AC_UL115_.jpg) |
|  9 | Amazon   | [Ethernet cable](https://www.amazon.com/Cat-Ethernet-Cable-White-Connectors/dp/B01IQWGRPU/ref=sr_1_3?dchild=1&keywords=network+cable&qid=1604589880&refinements=p_n_feature_keywords_three_browse-bin%3A7070221011&rnid=5462369011&s=pc&sr=1-3)                                                                                                                                                                                                                                                                               | 6          | 6.64    | 2       | 13.28    |                                                                                                                                                                                                                                                                                                                                         | ![](https://images-na.ssl-images-amazon.com/images/I/71YTQEXpoKL._AC_UL115_.jpg)   |
| 10 |          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |            |         |         | ======== |                                                                                                                                                                                                                                                                                                                                         |                                                                                    |
| 11 |          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |            |         |         | 907.63   |                                                                                                                                                                                                                                                                                                                                         |                                                                                    |

<!--PARTS-->




























