import 'package:flutter/material.dart';
import 'package:responsive_property/responsive_property.dart';

///predefined screen scopes
///using two breakpoints: mobile - tablet - desktop
///using one breakpoint: small - big

const double mobileScreenWidthLimit = 480.0;
const double tabletScreenWidthLimit = 840.0;
const double desktopScreenWidthLimit = 1200.0;

const double smallScreenWidthLimit = 600;
const double smallScreenHeightLimit = 1000.0;

const mobileScreenScope = ScreenScope(maxWidth: mobileScreenWidthLimit);
const tabletScreenScope = ScreenScope(
    minWidth: mobileScreenWidthLimit, maxWidth: tabletScreenWidthLimit);
const desktopScreenScope = ScreenScope(minWidth: tabletScreenWidthLimit);

const smallScreenScope = ScreenScope(maxWidth: smallScreenWidthLimit);
const bigScreenScope = ScreenScope(minWidth: smallScreenWidthLimit);

const mobilePortraitScreenScope = ScreenScope(
    maxWidth: mobileScreenWidthLimit, orientation: Orientation.portrait);
const tabletPortraitScreenScope = ScreenScope(
    minWidth: mobileScreenWidthLimit,
    maxWidth: tabletScreenWidthLimit,
    orientation: Orientation.portrait);
const desktopPortraitScreenScope = ScreenScope(
    minWidth: tabletScreenWidthLimit, orientation: Orientation.portrait);

const smallPortraitScreenScope = ScreenScope(
    maxWidth: smallScreenWidthLimit, orientation: Orientation.portrait);
const bigPortraitScreenScope = ScreenScope(
    minWidth: smallScreenWidthLimit, orientation: Orientation.portrait);

const mobileLandscapeScreenScope = ScreenScope(
    maxWidth: tabletScreenWidthLimit, orientation: Orientation.landscape);
const tabletLandscapeScreenScope = ScreenScope(
    minWidth: tabletScreenWidthLimit,
    maxWidth: desktopScreenWidthLimit,
    orientation: Orientation.landscape);
const desktopLandscapeScreenScope = ScreenScope(
    minWidth: desktopScreenWidthLimit, orientation: Orientation.landscape);

const smallLandscapeScreenScope = ScreenScope(
    maxWidth: smallScreenHeightLimit, orientation: Orientation.landscape);
const bigLandscapeScreenScope = ScreenScope(
    minWidth: smallScreenHeightLimit, orientation: Orientation.landscape);
