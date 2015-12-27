# iosome

Some projects to practice what I learned in my algorithms class while practicing Swift

## LCS

An implementation of the longest common subsequence problem

Also includes an efficient implementation of the length of the LCS as well as longest increasing subsequence in one string (LIS)

## GraphIntervals

### Problem:

You own a small business that supplies gondola rides to tourists. Unfortunately, because of the reckless nature of tourists in your area, you find yourself constantly making repairs on your gondolas. Some days your fleet is drastically diminished and you worry about not having enough operational gondolas to accommodate your customers. However, you do know the start and end times for all of the trips for any given day. You figure there must be a way to determine the minimum number of boats you need to get through a day without delays.

### My Solution:

1. Take in the list of intervals representing the start and end times for trips on a certain day.
2. Create a graph where a vertex is an trip with a start and end time and an edge between two vertices represents an overlap in two trips on gondolas
3. Add each vertex to an interval tree (AVL tree) and add edges between graph vertices as overlaps occur in the interval tree
4. Color the graph such that no two adjacent vertices have the same color

The total number of colors used is the number of operational gondolas needed

A vertex color (mapped to a trip interval) represents the ID of the boat that can be used for that trip