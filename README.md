# Interval Tree

## Problem

You own a small business that supplies gondola rides to tourists. Unfortunately, because of the reckless nature of tourists in your area, you find yourself constantly making repairs on your gondolas. Some days your fleet is drastically diminished and you worry about not having enough operational gondolas to accommodate your customers. However, you do know the start and end times for all trips on a given day. You figure there must be a way to determine the minimum number of boats you need to get through a day without delays.

## My Solution

1. Take as input a list of time intervals representing the start and end times for gondola trips on a given day.
2. Determine overlap between trips efficiently by inserting each interval into an interval tree (AVL tree).
3. Construct a graph where trips are represented by vertices and overlap between two trips is represented as an edge between two vertices.
4. Color the graph vertices such that no two adjacent vertices have the same color using as few colors as possible.

The total number of colors used is the number of operational gondolas needed and the vertex color can be used to select the boat for that trip.
