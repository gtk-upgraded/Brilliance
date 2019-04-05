#!/bin/bash

sass -C --sourcemap=none src/_gtk.scss gtk-3.0/gtk.css

sass -C --sourcemap=none src/_common.scss gtk-3.0/gtk-widgets.css
