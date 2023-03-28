## code to prepare `image_details` dataset goes here

image_details <- list(
  "PaviaC" = list(
    "urls" = c(
      "http://www.ehu.eus/ccwintco/uploads/e/e3/Pavia.mat",
      "http://www.ehu.eus/ccwintco/uploads/5/53/Pavia_gt.mat"
    ),
    "img" = "Pavia.mat",
    "img_key" = "pavia",
    "gt" = "Pavia_gt.mat",
    "gt_key" = "pavia_gt",
    "rgb_bands" = c(56, 42, 13),
    "label_values" = c(
      "Undefined",
      "Water",
      "Trees",
      "Asphalt",
      "Self-Blocking Bricks",
      "Bitumen",
      "Tiles",
      "Shadows",
      "Meadows",
      "Bare Soil"
    ),
    "ignored_labels" = c(0)
  ),

  "Salinas" = list(
    "urls" = c(
      "http://www.ehu.eus/ccwintco/uploads/a/a3/Salinas_corrected.mat",
      "http://www.ehu.eus/ccwintco/uploads/f/fa/Salinas_gt.mat"
    ),
    "img" = "Salinas_corrected.mat",
    "img_key" = "salinas.corrected",
    "gt" = "Salinas_gt.mat",
    "gt_key" = "salinas_gt",
    "rgb_bands" = c(44, 22, 12),
    "label_values" = c(
      "Undefined",
      "Brocoli_green_weeds_1",
      "Brocoli_green_weeds_2",
      "Fallow",
      "Fallow_rough_plow",
      "Fallow_smooth",
      "Stubble",
      "Celery",
      "Grapes_untrained",
      "Soil_vinyard_develop",
      "Corn_senesced_green_weeds",
      "Lettuce_romaine_4wk",
      "Lettuce_romaine_5wk",
      "Lettuce_romaine_6wk",
      "Lettuce_romaine_7wk",
      "Vinyard_untrained",
      "Vinyard_vertical_trellis"
    ),
    "ignored_labels" = c(0)
  ),

  "PaviaU" = list(
    "urls" = c(
      "http://www.ehu.eus/ccwintco/uploads/e/ee/PaviaU.mat",
      "http://www.ehu.eus/ccwintco/uploads/5/50/PaviaU_gt.mat"
    ),
    "img" = "PaviaU.mat",
    "img_key" = "paviaU",
    "gt" = "PaviaU_gt.mat",
    "gt_key" = "paviaU_gt",
    "rgb_bands" = c(56, 42, 13),
    "label_values" = c(
      "Undefined",
      "Asphalt",
      "Meadows",
      "Gravel",
      "Trees",
      "Painted metal sheets",
      "Bare Soil",
      "Bitumen",
      "Self-Blocking Bricks",
      "Shadows"
    ),
    "ignored_labels" = c(0)
  ),

  "KSC" = list(
    "urls" = c(
      "http://www.ehu.es/ccwintco/uploads/2/26/KSC.mat",
      "http://www.ehu.es/ccwintco/uploads/a/a6/KSC_gt.mat"
    ),
    "img" = "KSC.mat",
    "img_key" = "KSC",
    "gt" = "KSC_gt.mat",
    "gt_key" = "KSC_gt",
    "rgb_bands" = c(44, 22, 12),
    "label_values" = c(
      "Undefined",
      "Scrub",
      "Willow swamp",
      "Cabbage palm hammock",
      "Cabbage palm/oak hammock",
      "Slash pine",
      "Oak/broadleaf hammock",
      "Hardwood swamp",
      "Graminoid marsh",
      "Spartina marsh",
      "Cattail marsh",
      "Salt marsh",
      "Mud flats",
      "Water"
    ),
    "ignored_labels" = c(0)
  ),

  "IndianPines" = list(
    "urls" = c(
      "http://www.ehu.eus/ccwintco/uploads/6/67/Indian_pines_corrected.mat",
      "http://www.ehu.eus/ccwintco/uploads/c/c4/Indian_pines_gt.mat"
    ),
    "img" = "Indian_pines_corrected.mat",
    "img_key" = "indian.pines.corrected",
    "gt" = "Indian_pines_gt.mat",
    "gt_key" = "indian_pines_gt",
    "rgb_bands" = c(44, 22, 12),
    "label_values" = c(
      "Undefined",
      "Alfalfa",
      "Corn-notill",
      "Corn-mintill",
      "Corn",
      "Grass-pasture",
      "Grass-trees",
      "Grass-pasture-mowed",
      "Hay-windrowed",
      "Oats",
      "Soybean-notill",
      "Soybean-mintill",
      "Soybean-clean",
      "Wheat",
      "Woods",
      "Buildings-Grass-Trees-Drives",
      "Stone-Steel-Towers"
    ),
    "ignored_labels" = c(0)
  ),

  "Botswana" = list(
    "urls" = c(
      "http://www.ehu.es/ccwintco/uploads/7/72/Botswana.mat",
      "http://www.ehu.es/ccwintco/uploads/5/58/Botswana_gt.mat"
    ),
    "img" = "Botswana.mat",
    "img_key" = "Botswana",
    "gt" = "Botswana_gt.mat",
    "gt_key" = "Botswana_gt",
    "rgb_bands" = c(76, 34, 16),
    "label_values" = c(
      "Undefined",
      "Water",
      "Hippo grass",
      "Floodplain grasses 1",
      "Floodplain grasses 2",
      "Reeds",
      "Riparian",
      "Firescar",
      "Island interior",
      "Acacia woodlands",
      "Acacia shrublands",
      "Acacia grasslands",
      "Short mopane",
      "Mixed mopane",
      "Exposed soils"
    ),
    "ignored_labels" = c(0)
  )
)

usethis::use_data(image_details, overwrite = TRUE, internal = TRUE)
