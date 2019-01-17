
## Tyler

[![Build Status](https://travis-ci.org/IgorMuzyka/Tyler.svg?branch=master)](https://travis-ci.org/IgorMuzyka/Tyler)

## About

Tyler is a toolkit designed to allow declarative style user interface definition from code using flexible and extendable DSL format.

Tyler is inspired by [LeeGo](https://github.com/wangshengjia/LeeGo) but done in another manner and it's modules borrow ideas from other repositories such as: [Anchors](https://github.com/onmyway133/Anchors), [On](https://github.com/onmyway133/On), [Hashids](https://github.com/malczak/hashids). 

⚠️ **Beware**: Tyler is not production ready by any means.



**Goals:**

- Ability to define UI(and a bit more) for iOS/tvOS/macOS anywhere Swift can run(including linux).
- Flexible and Extendable DSL.
- Persistable and Restorable UI definition.



## Example usage

To be done.

## Current project status

#### What's ready

- Anchors
- Tag
- Identifiers

#### Partially ready

- Style
- Susbstitutes
- UIKit support

#### Totally a mess

- Actions
- AppKit support

#### Nonexistent yet

- Essentials module
- Example module
- Partial/Diffed render

## Repositories (dependency layering)

**Level 0** (Basic types required for minimum functionality)

- [Identifier](https://github.com/IgorMuzyka/Tyler.Identifier)

- [Tag](https://github.com/IgorMuzyka/Tyler.Tag)

- [Variable](https://github.com/IgorMuzyka/Tyler.Variable)
- [Action](https://github.com/IgorMuzyka/Tyler.Action)

**Level 1**

- [Anchor](https://github.com/IgorMuzyka/Tyler.Anchor) - codable & declarative layout DSL definition which is interpreted into NSLayoutConstraints by Tyler.
- [Style](https://github.com/IgorMuzyka/Tyler.Style) - a base framework required to design Style & Stylist definitions.

**Level 2**

- [Substitutes](https://github.com/IgorMuzyka/Tyler.Substitutes) - types to be used instead of platform specific types.
- [Tyler](https://github.com/IgorMuzyka/Tyler) - allows you to layout, style & actionate Tiles into Contexts.

**Level 3** (Styles DSL)

- [Support Apple Common](https://github.com/IgorMuzyka/Tyler.Support.Apple.Common)
- [Support Apple UIKit](https://github.com/IgorMuzyka/Tyler.Support.Apple.UIKit)
- [Support Apple AppKit](https://github.com/IgorMuzyka/Tyler.Support.Apple.AppKit)



## Roadmap

- [ ] Example project [36h+?]
  - [ ] Local usage example. [8h]
    - [ ] Select a design to reporduce. [2h]
    - [ ] Basic screen with different layouts for landscape and portrait modes (for example Profile). [6h]
  - [ ] Vapor API example. [26h]
    - [ ] An interactive list layout with options to add and remove entities while the whole design should be provided by the backend as a response. [12h]
    - [ ] Select a design to reporduce. [2h]
    - [ ] Button action example(s). [6h]
    - [ ] Variables utilisation example(change some UI parameters from within UI). [6h]
  - [ ] Essentials module. [?h]
    - [ ] TileViewController. [?h]
    - [ ] RemoteTileViewController. [?h]
    - [ ] A module itself. [2h]
- [ ] Test coverage for modules which need it. [32h]
  - [ ] Variable. [4h]
  - [ ] Tag. [4h]
  - [ ] Identifier. [3h]
  - [ ] Anchor. [6h]
  - [ ] Tyler. [6h]
  - [ ] Support.Apple.UIKIt. [3h]
  - [ ] Support.Apple.AppKit. [3h]
  - [ ] Support.Apple.Common. [3h]