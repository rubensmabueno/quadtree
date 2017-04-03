# Spotippos Reign

This project is a generic representation of properties location challenge proposed in [here](https://github.com/VivaReal/code-challenge/blob/master/backend.md).

## Introduction

For this project, most of the focus is on resolving the point location and bounding box algorithm. Language and Framework choices are focused on readability and maintainability only, since most of the features which comes from it shares a lot in common with most other challenge proposals.

### QuadTree
Location indexing is not trivial. A location is most of the time composed by latitude and longitude, which for hash indexing of ```1_000``` locations, would give us ```1_000 * 1_000``` indexes combinations.

Seeking to resolve this indexing problem, I optioned for using the most straightforward spatial indexing, which is [Quadtree](https://en.wikipedia.org/wiki/Quadtree). An interactive explanation can be found [here](http://jimkang.com/quadtreevis/).

In order to resolve both location problems proposed, I implemented a specific version of the QuadTree algorithm which can increase the project performance in both cases.

- For province finding (point location within area) from ```O(n)``` (in a linear comparator) to ```O(n)``` at maximum and ```O(log(n))``` on mean, where `n` is the number of provinces.
- For bounding box (point searching within area) from ```O(n)``` (in a linear comparator) to ```O(log(n))``` at maximum, where `n` is the number of properties.

#### Benchmark:

Test:
```ruby
properties = Spotippos::Kingdom.properties
rectangle = Quadtree::Rectangle.new(Quadtree::Point.new(0, 600), Quadtree::Point.new(600, 300))

# Simple comparator
puts Benchmark.measure { properties.select { |property| rectangle.contains?(property) } }

# Quadtree
puts Benchmark.measure { Spotippos::Kingdom.find_properties(rectangle) }
```

Output:
```
Simple comparator
 0.000000   0.000000   0.000000 (  0.003174)
Quadtree
 0.000000   0.000000   0.000000 (  0.000330)
```

_* The Quadtree implementation is almost entirely decoupled from project. On future, my desire is to extract it to a Gem since most of the Quadtree libs in Ruby looks very complex and not easily usable_

## Getting Started

In order to run this project, you'll need to clone this repository on you machine.

### Prerequisites

All installation steps are divided between ```Docker``` and ```Direct```. It's up to you to choose your favorite flavor.

#### Docker

```
docker (>17.0)
```

#### Direct

```
ruby (>2.3)
```

### Installing

After installation, you can access the API through the endpoint ```http://localhost:9292```.

#### Docker

- On the project root, build:

```docker build -t spotippos .```

- Runs:

```docker run -p 9292:9292 spotippos```

#### Direct

- On the project root, install dependencies:

```bundle install```

- Get rack up and running with:

```rackup```

## Running the tests

These tests are written in RSpec, all of the more complex cases (which contains the property locator) are fully covered. I didn't want to overlap with tests most of the framework methods call since they are already covered by the framework.

### Docker

- Run with:
```docker run spotippos rspec```

### Direct

- On the project root, run:
```rspec```

## Built With

* [Grape](https://github.com/ruby-grape/grape/) - REST-like API framework for Ruby
* [Roar](https://github.com/trailblazer/roar) - Framework for parsing and rendering REST documents

## Authors

* **Rubens Minoru Andako Bueno** - [GitHub](https://github.com/rubensmabueno)
