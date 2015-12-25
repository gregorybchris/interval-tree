# iosome

Algorithms implemented in Swift to test some ideas out that I learned in my algorithms class while getting better at Swift

## GraphIntervals

**Problem:**

You own a small business that supplies gondola rides to tourists. Unfortunately, because of the reckless nature of tourists in your area, you find yourself constantly making repairs on your gondolas. Some days your fleet is drastically diminished and you worry about not having enough operational gondolas to accommodate your customers. However, you do know the start and end times for all of the trips for any given day. You figure there must be a way to determine the minimum number of boats you need to get through a given day without delays.

**Solution:**

1. Take in the list of intervals representing the start and end times for trips on a certain day.
2. Sort the list (primarily by start times, then by end times)
3. Find all pairs of overlapping intervals in the list
4. Create a graph where a vertex is an interval and an edge between two vertices represents an overlap
5. Color the graph such that no two adjacent vertices have the same color

The total number of colors used is the number of operational gondolas needed

**Additional Information:**

A vertex colors (mapped to a trip interval) represents the ID of the boat that can be used for that trip

**Future Additions:**

Optimizing the worker shifts is another problem