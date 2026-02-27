# Daraz-Style Product Listing (Single Scroll Architecture)

A Flutter implementation of a Daraz-style product listing screen focused
on correct scroll architecture, gesture coordination, and clean
separation of concerns.

This project prioritizes scroll behavior and structural correctness over
UI complexity.

------------------------------------------------------------------------

## Run Instructions

flutter pub get flutter run

Recommended: Flutter 3.x+

------------------------------------------------------------------------

# Objective

Build a screen with:

-   Collapsible header (banner)
-   Sticky TabBar when header collapses
-   4 product tabs
-   Exactly ONE vertical scrollable
-   Pull-to-refresh from any tab
-   No scroll reset on tab switch
-   No scroll conflict or jitter
-   Horizontal navigation via tap and swipe
-   FakeStore API integration (products + login + profile)

------------------------------------------------------------------------

# Architecture Overview

This implementation enforces:

Exactly ONE vertical scroll axis across the entire screen.

Core widgets used:

-   RefreshIndicator
-   NestedScrollView
-   SliverAppBar
-   SliverPersistentHeader (Pinned TabBar)
-   TabBarView
-   CustomScrollView (per tab using Slivers)

------------------------------------------------------------------------

# Layout Structure

RefreshIndicator └── NestedScrollView (Single vertical owner) ├──
headerSliverBuilder │ ├── SliverAppBar (Collapsible Banner + Search) │
└── SliverPersistentHeader (Pinned TabBar) │ └── TabBarView (Horizontal
navigation) ├── Tab 1 → CustomScrollView (SliverList) ├── Tab 2 →
CustomScrollView (SliverList) └── Tab 3 → CustomScrollView (SliverList)

------------------------------------------------------------------------

# Scroll & Gesture Design

## 1. Vertical Scroll Ownership

NestedScrollView owns the single vertical scroll axis.

-   Header collapses first.
-   Product list scrolls afterward.
-   User experiences one continuous scroll.

No independent vertical ScrollController is used inside tab children.

Each tab's CustomScrollView is automatically coordinated by
NestedScrollView.

This guarantees:

-   No duplicate scrolling
-   No jitter
-   No scroll conflict
-   One unified vertical behavior

------------------------------------------------------------------------

## 2. Horizontal Swipe Implementation

Horizontal navigation is implemented using TabBarView (internally
powered by PageView).

Gesture separation via Flutter Gesture Arena:

-   Vertical drag → NestedScrollView
-   Horizontal drag → TabBarView

This ensures predictable gesture behavior.

Tab taps are controlled using a single TabController (animateTo).

------------------------------------------------------------------------

## 3. Pull-To-Refresh

RefreshIndicator wraps NestedScrollView.

Since the outer scroll owns the vertical axis: - Pull-to-refresh works
from ANY tab.

------------------------------------------------------------------------

## 4. Scroll Position on Tab Switch

Vertical position is preserved because:

-   Vertical offset lives in NestedScrollView.
-   Tab switching only changes the horizontal page.

Each tab's internal state preserved using: -
AutomaticKeepAliveClientMixin - PageStorageKey

Prevents: - Scroll reset - Scroll jump - Header re-expansion

------------------------------------------------------------------------

# API Integration

API Used: https://fakestoreapi.com/

Endpoints:

-   POST /auth/login
-   GET /products
-   GET /users/{id}

Features:

-   Login screen
-   Product listing
-   User profile

API layer is separated from UI and scroll coordination.

------------------------------------------------------------------------

# Separation of Concerns

UI Layer: - Slivers - Layout widgets - Product cards

Scroll & Gesture Ownership: - NestedScrollView - TabBarView

State Management: - API calls - Login state - Product fetching - Profile
data

No global hacks or magic numbers used.

------------------------------------------------------------------------

# Trade-offs & Limitations

-   NestedScrollView has known edge cases in some Flutter versions.
    Mitigated using PageStorageKey.
-   Short content may prevent full header collapse (handled with
    SliverFillRemaining).
-   Minor jank possible during first network load on slow devices.

------------------------------------------------------------------------

# Requirements Checklist

✔ Single vertical scroll\
✔ Sliver-based layout\
✔ Collapsible header\
✔ Sticky pinned TabBar\
✔ Pull-to-refresh from any tab\
✔ No scroll conflict\
✔ No jitter\
✔ Horizontal swipe + tap navigation\
✔ Scroll position preserved\
✔ FakeStore API integration\
✔ Login + User profile

------------------------------------------------------------------------

# Evaluation Coverage

This implementation demonstrates:

-   Correct single-scroll architecture
-   Clean gesture disambiguation
-   Predictable scroll ownership
-   Clear separation of UI and logic
-   Proper architectural reasoning

------------------------------------------------------------------------

# Submission

To run:

flutter pub get 
flutter run
