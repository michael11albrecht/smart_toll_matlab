
---

# Smart Toll Application

This application is a MATLAB-based UI tool for initializing and calculating routes on a map segment.

## Installation

To install the application, run the `Smart Toll.mlappinstall` file. This will install the MATLAB app UI on your system.

### Initialize filesystem:
1. **Add Geoapify api-key**: Get your own [Geoapify api-key](https://www.geoapify.com). Create a `config.env` file containing: ```geoapify_key = your_api_key```
2. **Add a data folder**: Create a folder called `Daten` containing the folder `shapefile` which contains the shapefile of the [French road-network](https://geoservices.ign.fr/route500#telechargement).
```
│
├── smart_toll_matlab/
│   ├── ... (other directories and files in the repository)
│   └── config.env (to be created by the user)
│
└── Daten/
    └── shapefile/
        └── ... (shapefile data of the French road-network)
```

## Usage

1. **Initialize a Map Segment**: In the UI, search for a town in the provided search field and hit the 'Init' button. This runs the [`init`](command:_github.copilot.openSymbolInFile?%5B%22init.m%22%2C%22init%22%5D "init.m") function which initializes the map segment for the specified town.

2. **Calculate a Route**: After initializing the area, you can calculate a route within this area. Type two addresses in the provided text fields and hit the 'Calculate' button. This runs the [`main`](command:_github.copilot.openSymbolInFile?%5B%22main.m%22%2C%22main%22%5D "main.m") function which calculates the route between the two specified addresses.

Please note that the addresses should be within the initialized map segment.


## Functions Description

### Init:

- **getLatLonAddress:**
  - Makes an API call with text input to `https://www.geoapify.com`.
  - Returns the resulting latitude and longitude coordinates.

- **latLon2Lambert:**
  - Converts latitude and longitude coordinates from WGS84 to Lambert93 projection.

- **loadCleanShapefile:**
  - Reads the shapefile while filtering out empty segments.

- **deleteUnessesary:**
  - Deletes unnecessary columns in the shapefile.

- **renameItemAttributes:**
  - Renames the remaining columns.
  - Introduces a Segment ID (integer).

- **createTileSpecific:**
  - Calculates a tile (square).
  - Stores the street segments within the square.

- **filterHighway:**
  - Finds all highways and dual carriageway national roads.
  - Identifies adjoining segments to these expressways (by name).
  - Creates a separate shapefile for these found segments.

- **secDeleteUnessesary:**
  - Deletes now unnecessary columns post filtering.

- **compactShapefile:**
  - Connects contiguous segments.
  - Segments remain separated at: intersections, local road to expressway changes, and toll to toll-free transitions.

- **createTiles:**
  - Calculates all tiles necessary to represent the shapefile.
  - Saves the files, naming them with the minimum coordinates.

- **shapefileToAdjMatrix:**
  - Computes a list of shapefile plus coordinates from the shapefile.

- **makeMainGraph:**
  - Searches for the largest connected graph, custom Minimum Spanning Tree (MST) algorithm.

- **secBuildHwShapefile:**
  - Creates a shapefile that contains only expressways (from the processed shapefile).

- **findRamps:**
  - Searches for all expressway ramps.
  - Returns a list with coordinates and Segment IDs.

### Main:

- **getLatLonAddress:**
  - Makes an API call with text input to `https://www.geoapify.com`.
  - Returns the resulting latitude and longitude coordinates.

- **latLon2Lambert:**
  - Converts latitude and longitude coordinates from WGS84 to Lambert93 projection.

- **getBaseTile:**
  - Calculates the necessary base tile and checks if it exists.

- **withoutHw:**
  - Calculates the route using a simple A* algorithm.

- **withHw:**
  - Calculates the route using an A* algorithm with highway heuristic.

- **findNearestRamp:**
  - Finds the nearest ramp to the given point from the ramp list.

- **decideHwLocal:**
  - Decides between a highway route and a simple A* based on the shortest line between the start/end point and the ramp, and between the start and end points.

- **calcNeededTiles:**
  - Calculates points at the distance of the tile-size along the shortest line.
  - Determines the necessary tiles to represent all points.

- **checkForTiles:**
  - Checks if all calculated tiles are present.

- **stichTiles:**
  - Loads the necessary tiles and merges them into a single shapefile.

- **shapefileToAdjMatrix:**
  - Creates a shapefile and coordinates list from the shapefile.

- **makeMainGraph:**
  - Searches for the largest connected graph, similar to the Minimum Spanning Tree (MST) algorithm.

- **p2pMatching:**
  - Finds the closest segment to the given point.
  
- **aStarMiddle:**
  - Calculates three routes (start-highway-end) and connects them.

- **buildRouteShapefile:**
  - Creates a shapefile composed of the segments needed for the route.

- **aStar:**
  - Calculates a route from the start to the endpoint.

- **shapefile2LatLon:**
  - Returns all the points of the shapefile segments in contiguous sequence as latitude, longitude WGS84 coordinates.

- **calcMapLimits:**
  - Calculates the necessary map size (with an additional 20% of the shortest line as overscan).

- **lambert2LatLon:**
  - Converts Lambert93 coordinates back to latitude and longitude WGS84.

---