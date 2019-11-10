library(osmdata)
library(sf)
osm <- osmdata_sf(
  add_osm_feature(
    opq(bbox = st_bbox(gCO)),
    key = 'highway'))$osm_lines[, c("highway")]
st <- c("motorway", "motorway_link", "trunk", "trunk_link",
        "primary", "primary_link", "secondary", "secondary_link",
        "tertiary", "tertiary_link")
osm <- osm[osm$highway %in% st, ]