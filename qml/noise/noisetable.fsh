const int P[256] = int[256] (
    103, 1, 16, 123, 167, 238, 242, 24, 132, 192, 36, 109, 128, 85, 121, 90, 
    151, 70, 158, 60, 165, 130, 19, 214, 200, 68, 250, 147, 48, 41, 55, 189, 
    100, 168, 220, 33, 136, 102, 144, 15, 30, 0, 137, 161, 157, 138, 45, 124, 
    179, 4, 29, 230, 212, 7, 2, 153, 82, 56, 105, 209, 6, 178, 42, 21, 
    231, 159, 52, 177, 113, 169, 118, 183, 114, 18, 182, 203, 213, 248, 80, 87, 
    142, 201, 172, 208, 198, 154, 112, 81, 93, 196, 155, 98, 53, 206, 149, 10, 
    40, 217, 120, 108, 251, 229, 71, 61, 243, 166, 139, 78, 235, 241, 22, 216, 
    129, 13, 218, 74, 180, 84, 126, 20, 173, 91, 127, 111, 65, 83, 133, 63, 
    47, 163, 79, 106, 193, 145, 86, 57, 175, 185, 5, 54, 215, 37, 176, 224, 
    38, 67, 210, 228, 75, 222, 46, 62, 150, 69, 174, 25, 3, 32, 186, 146, 
    59, 31, 35, 219, 77, 110, 160, 64, 11, 199, 115, 28, 253, 17, 233, 39, 
    187, 58, 204, 152, 227, 194, 252, 27, 125, 51, 191, 207, 226, 211, 8, 221, 
    240, 117, 170, 246, 101, 119, 73, 164, 135, 50, 141, 188, 94, 205, 162, 140, 
    181, 26, 89, 249, 148, 66, 236, 88, 195, 95, 190, 43, 254, 156, 197, 116, 
    237, 244, 92, 107, 234, 171, 225, 23, 131, 9, 49, 184, 97, 14, 34, 76, 
    232, 255, 72, 134, 223, 104, 44, 239, 202, 143, 247, 122, 96, 245, 12, 99
);
const vec2 G2[256] = vec2[256] (
    vec2(-0.932, 0.363), vec2(0.867, 0.498), vec2(-0.596, 0.803), vec2(-0.971, -0.24), vec2(0.999, 0.006), vec2(0.905, 0.424), 
    vec2(0.317, 0.948), vec2(0.839, 0.543), vec2(0.522, 0.852), vec2(0.054, -0.999), vec2(-0.902, 0.432), vec2(-0.558, 0.83), 
    vec2(0.955, 0.293), vec2(0.998, -0.063), vec2(-0.116, -0.994), vec2(-0.562, -0.828), vec2(-0.727, -0.688), vec2(0.925, 0.379), 
    vec2(0.913, 0.406), vec2(-0.906, 0.424), vec2(0.95, 0.311), vec2(-0.23, 0.973), vec2(0.482, 0.875), vec2(-0.804, 0.594), 
    vec2(0.144, -0.99), vec2(-0.489, 0.872), vec2(0.319, -0.948), vec2(0.916, -0.401), vec2(0.152, 0.988), vec2(0.965, -0.262), 
    vec2(-0.946, -0.327), vec2(-1, 0.022), vec2(-0.975, 0.226), vec2(0.989, 0.142), vec2(-0.75, 0.661), vec2(-0.78, -0.627), 
    vec2(-0.419, -0.909), vec2(-0.948, -0.32), vec2(0.948, 0.317), vec2(0.315, -0.949), vec2(0.968, -0.249), vec2(0.341, 0.939), 
    vec2(0.261, 0.965), vec2(-0.925, 0.38), vec2(-0.548, -0.838), vec2(0.811, -0.585), vec2(-0.75, -0.663), vec2(-0.63, 0.776), 
    vec2(0.52, -0.855), vec2(-0.233, -0.973), vec2(0.17, 0.985), vec2(-1, -0.003), vec2(0.744, -0.668), vec2(0.386, 0.922), 
    vec2(-0.154, -0.989), vec2(0.337, 0.941), vec2(-0.717, -0.698), vec2(-0.328, 0.944), vec2(-0.45, -0.894), vec2(0.999, 0.033), 
    vec2(-0.814, 0.581), vec2(0.757, 0.652), vec2(0.999, 0.014), vec2(0.994, 0.104), vec2(-0.993, -0.125), vec2(-0.079, 0.996), 
    vec2(0.585, 0.81), vec2(-0.988, 0.155), vec2(-0.827, -0.564), vec2(-0.346, 0.938), vec2(-0.782, -0.625), vec2(0.113, 0.993), 
    vec2(-0.201, -0.98), vec2(-0.327, -0.946), vec2(0.483, 0.875), vec2(-0.477, -0.88), vec2(-0.816, -0.579), vec2(-1, 0.024), 
    vec2(0.998, -0.052), vec2(-0.721, 0.693), vec2(-0.552, 0.833), vec2(-0.886, 0.464), vec2(-0.486, 0.874), vec2(-0.713, 0.701), 
    vec2(0.832, -0.554), vec2(0.041, -1), vec2(-0.955, -0.3), vec2(0.89, 0.455), vec2(0.821, 0.569), vec2(-0.986, 0.171), 
    vec2(-0.474, -0.882), vec2(0.403, -0.916), vec2(0.718, -0.696), vec2(0.71, -0.704), vec2(0.905, -0.425), vec2(-0.912, -0.413), 
    vec2(0.988, 0.152), vec2(-0.983, -0.186), vec2(0.558, -0.83), vec2(-0.95, 0.313), vec2(-0.962, 0.273), vec2(-0.569, -0.823), 
    vec2(-0.652, -0.759), vec2(0.464, 0.885), vec2(-0.964, 0.268), vec2(0.448, 0.893), vec2(0.963, 0.267), vec2(-0.64, 0.768), 
    vec2(-0.457, 0.889), vec2(0.732, -0.681), vec2(-0.609, 0.793), vec2(-0.306, 0.952), vec2(0.719, 0.693), vec2(0.232, 0.972), 
    vec2(0.84, -0.542), vec2(0.394, 0.919), vec2(-0.678, 0.735), vec2(0.961, -0.277), vec2(0.857, 0.514), vec2(0.242, 0.97), 
    vec2(-0.68, -0.734), vec2(0.089, -0.996), vec2(-0.798, -0.603), vec2(-0.696, -0.719), vec2(-0.628, -0.779), vec2(0.363, -0.932), 
    vec2(-0.771, 0.637), vec2(-0.713, 0.702), vec2(0.931, -0.364), vec2(-0.22, 0.975), vec2(-0.681, -0.733), vec2(0.108, -0.995), 
    vec2(0.077, 0.996), vec2(-0.993, 0.121), vec2(-0.823, -0.569), vec2(0.933, 0.359), vec2(-0.954, 0.3), vec2(0.999, 0), 
    vec2(0.907, -0.421), vec2(0.836, 0.548), vec2(-0.992, 0.127), vec2(-0.249, -0.969), vec2(-0.477, 0.879), vec2(-0.258, 0.966), 
    vec2(0.95, 0.31), vec2(0.982, -0.189), vec2(0.894, -0.447), vec2(-0.09, 0.995), vec2(0.997, -0.068), vec2(0.815, 0.578), 
    vec2(0.315, -0.95), vec2(0.997, 0.068), vec2(-0.078, -0.998), vec2(-0.642, -0.767), vec2(-0.79, 0.614), vec2(0.926, 0.377), 
    vec2(0.7, 0.713), vec2(0.578, 0.815), vec2(0.681, -0.733), vec2(-0.469, 0.883), vec2(0.733, -0.68), vec2(-0.998, 0.074), 
    vec2(-0.99, -0.146), vec2(-0.778, 0.628), vec2(0.784, 0.62), vec2(-0.322, -0.947), vec2(-0.417, -0.91), vec2(-0.999, -0.061), 
    vec2(0.776, -0.631), vec2(-0.761, -0.65), vec2(0.325, -0.946), vec2(-0.082, 0.996), vec2(-0.089, 0.996), vec2(-1, -0.015), 
    vec2(-0.05, -0.999), vec2(-0.549, 0.836), vec2(-0.476, -0.88), vec2(0.379, -0.926), vec2(0.077, -0.998), vec2(-0.885, 0.466), 
    vec2(0.698, -0.716), vec2(-0.173, -0.986), vec2(-0.766, 0.643), vec2(-0.984, -0.183), vec2(-0.259, -0.967), vec2(-0.041, -1), 
    vec2(0.134, -0.991), vec2(-0.469, 0.883), vec2(-0.8, 0.6), vec2(-0.643, 0.766), vec2(0.999, -0.001), vec2(-0.699, -0.716), 
    vec2(-0.238, 0.971), vec2(-0.699, -0.716), vec2(-0.08, -0.997), vec2(0.763, 0.645), vec2(0.921, -0.388), vec2(-0.239, -0.972), 
    vec2(0.367, 0.93), vec2(-0.172, 0.985), vec2(-0.274, 0.961), vec2(-0.771, 0.637), vec2(-0.241, 0.97), vec2(0.112, 0.993), 
    vec2(0.787, 0.616), vec2(-0.87, -0.494), vec2(-0.14, 0.99), vec2(0.424, -0.906), vec2(-0.819, 0.574), vec2(-0.79, 0.613), 
    vec2(-0.119, -0.993), vec2(-0.315, 0.949), vec2(-0.769, -0.64), vec2(-0.716, -0.699), vec2(0.383, 0.923), vec2(0.877, -0.479), 
    vec2(0.105, -0.995), vec2(-0.643, -0.767), vec2(0.094, 0.995), vec2(-0.795, 0.607), vec2(0.165, 0.986), vec2(-0.246, 0.969), 
    vec2(0.924, 0.38), vec2(0.723, 0.69), vec2(0.594, 0.804), vec2(0.999, -0.04), vec2(-0.968, -0.254), vec2(-0.804, -0.596), 
    vec2(-0.958, -0.289), vec2(0.999, -0.013), vec2(-0.604, 0.797), vec2(0.58, -0.815), vec2(-0.887, -0.464), vec2(0.053, -0.999), 
    vec2(-0.981, -0.198), vec2(0.198, -0.981), vec2(-0.613, 0.79), vec2(-0.714, 0.7), vec2(-0.99, -0.145), vec2(0.999, 0.039), 
    vec2(-0.915, 0.404), vec2(0.777, -0.629), vec2(-0.848, -0.531), vec2(-0.746, -0.667), vec2(0.612, 0.79), vec2(0.041, -1), 
    vec2(0.192, 0.981), vec2(-0.987, 0.161), vec2(-0.879, 0.477), vec2(-0.983, 0.187), vec2(-0.785, -0.621), vec2(0.994, 0.106), 
    vec2(0.298, -0.955), vec2(-0.956, 0.295), vec2(-0.917, -0.401), vec2(0.649, -0.761)
);
const vec3 G3[256] = vec3[256] (
    vec3(-0.632, 0.461, 0.461), vec3(0.619, 0.648, 0.648), vec3(0.898, -0.233, -0.233), vec3(-0.245, -0.819, -0.819), vec3(-0.581, -0.47, -0.47), vec3(-0.917, 0.298, 0.298), 
    vec3(-0.678, 0.047, 0.047), vec3(0.217, -0.823, -0.823), vec3(-0.979, -0.181, -0.181), vec3(0.671, 0.675, 0.675), vec3(0.457, -0.631, -0.631), vec3(0.806, -0.583, -0.583), 
    vec3(-0.559, -0.408, -0.408), vec3(0.881, -0.311, -0.311), vec3(0.361, 0.893, 0.893), vec3(0.266, 0.573, 0.573), vec3(0.222, -0.749, -0.749), vec3(0.241, -0.957, -0.957), 
    vec3(-0.536, -0.781, -0.781), vec3(0.166, 0.757, 0.757), vec3(0.633, -0.487, -0.487), vec3(0.049, 0.385, 0.385), vec3(-0.863, 0.356, 0.356), vec3(-0.369, -0.101, -0.101), 
    vec3(-0.159, 0.703, 0.703), vec3(-0.562, -0.611, -0.611), vec3(0.721, 0.29, 0.29), vec3(-0.424, -0.54, -0.54), vec3(0.707, -0.507, -0.507), vec3(0.734, 0.234, 0.234), 
    vec3(0.643, 0.709, 0.709), vec3(-0.788, -0.487, -0.487), vec3(0.663, -0.433, -0.433), vec3(0.847, -0.437, -0.437), vec3(0.185, -0.976, -0.976), vec3(0.853, 0.324, 0.324), 
    vec3(-0.763, -0.269, -0.269), vec3(-0.726, -0.512, -0.512), vec3(-0.993, -0.02, -0.02), vec3(0.23, -0.859, -0.859), vec3(0.22, -0.763, -0.763), vec3(0.342, 0.824, 0.824), 
    vec3(-0.326, 0.77, 0.77), vec3(-0.451, -0.842, -0.842), vec3(-0.518, 0.656, 0.656), vec3(0.679, 0.729, 0.729), vec3(-0.717, 0.014, 0.014), vec3(0.703, 0.409, 0.409), 
    vec3(-0.894, -0.172, -0.172), vec3(0.667, -0.725, -0.725), vec3(0.076, -0.585, -0.585), vec3(0.194, 0.936, 0.936), vec3(-0.452, -0.193, -0.193), vec3(0.348, -0.562, -0.562), 
    vec3(-0.973, -0.202, -0.202), vec3(-0.401, -0.141, -0.141), vec3(-0.829, 0.481, 0.481), vec3(0.865, 0.225, 0.225), vec3(-0.451, -0.615, -0.615), vec3(-0.782, -0.612, -0.612), 
    vec3(-0.101, -0.192, -0.192), vec3(-0.092, 0.841, 0.841), vec3(0.552, 0.004, 0.004), vec3(0.446, -0.628, -0.628), vec3(0.082, 0.522, 0.522), vec3(0.247, 0.709, 0.709), 
    vec3(-0.33, 0.409, 0.409), vec3(-0.731, -0.303, -0.303), vec3(0.509, 0.44, 0.44), vec3(0.638, 0.485, 0.485), vec3(0.789, 0.228, 0.228), vec3(-0.899, -0.439, -0.439), 
    vec3(0.148, 0.776, 0.776), vec3(-0.587, -0.811, -0.811), vec3(-0.649, 0.758, 0.758), vec3(-0.368, -0.757, -0.757), vec3(-0.206, 0.66, 0.66), vec3(-0.719, 0.016, 0.016), 
    vec3(0.288, 0.818, 0.818), vec3(-0.737, -0.635, -0.635), vec3(-0.282, -0.817, -0.817), vec3(0.783, 0.566, 0.566), vec3(-0.899, -0.346, -0.346), vec3(-0.375, 0.446, 0.446), 
    vec3(0.717, -0.204, -0.204), vec3(-0.308, -0.52, -0.52), vec3(-0.751, 0.376, 0.376), vec3(0.486, -0.546, -0.546), vec3(-0.783, 0.153, 0.153), vec3(0.922, 0.385, 0.385), 
    vec3(0.408, 0.85, 0.85), vec3(0.696, -0.712, -0.712), vec3(-0.393, 0.685, 0.685), vec3(0.842, -0.069, -0.069), vec3(0.646, 0.594, 0.594), vec3(-0.714, -0.53, -0.53), 
    vec3(-0.051, 0.923, 0.923), vec3(0.274, -0.418, -0.418), vec3(0.705, 0.123, 0.123), vec3(-0.779, -0.172, -0.172), vec3(-0.644, -0.404, -0.404), vec3(0.064, -0.728, -0.728), 
    vec3(0.461, -0.54, -0.54), vec3(-0.577, 0.654, 0.654), vec3(0.708, -0.454, -0.454), vec3(-0.151, -0.787, -0.787), vec3(-0.145, -0.185, -0.185), vec3(-0.365, 0.908, 0.908), 
    vec3(0.743, -0.278, -0.278), vec3(0.999, 0.04, 0.04), vec3(0.729, -0.652, -0.652), vec3(0.661, -0.594, -0.594), vec3(0.35, 0.061, 0.061), vec3(0.813, -0.436, -0.436), 
    vec3(-1, 0.022, 0.022), vec3(0.837, -0.427, -0.427), vec3(-0.378, -0.488, -0.488), vec3(-0.656, 0.532, 0.532), vec3(0.186, -0.86, -0.86), vec3(0.577, -0.528, -0.528), 
    vec3(0.617, -0.425, -0.425), vec3(0.998, 0.041, 0.041), vec3(0.508, 0.594, 0.594), vec3(0.533, -0.423, -0.423), vec3(-0.258, -0.808, -0.808), vec3(0.129, 0.674, 0.674), 
    vec3(-0.678, -0.126, -0.126), vec3(-0.093, -0.265, -0.265), vec3(0.808, -0.378, -0.378), vec3(0.543, 0.317, 0.317), vec3(0.619, -0.5, -0.5), vec3(-0.118, -0.652, -0.652), 
    vec3(-0.197, 0.702, 0.702), vec3(-0.707, -0.007, -0.007), vec3(-0.355, 0.735, 0.735), vec3(-0.26, 0.778, 0.778), vec3(-0.749, 0.54, 0.54), vec3(0.842, -0.042, -0.042), 
    vec3(-0.835, 0.358, 0.358), vec3(-0.089, -0.814, -0.814), vec3(-0.847, -0.293, -0.293), vec3(0.247, -0.061, -0.061), vec3(-0.55, -0.273, -0.273), vec3(0.015, 0.233, 0.233), 
    vec3(0.561, -0.086, -0.086), vec3(0.591, -0.564, -0.564), vec3(-0.627, -0.587, -0.587), vec3(-0.669, 0.666, 0.666), vec3(-0.149, 0.98, 0.98), vec3(-0.598, 0.515, 0.515), 
    vec3(0.476, 0.878, 0.878), vec3(0.374, 0.719, 0.719), vec3(-0.696, -0.708, -0.708), vec3(-0.658, -0.092, -0.092), vec3(-0.313, 0.572, 0.572), vec3(-0.499, -0.559, -0.559), 
    vec3(0.468, -0.678, -0.678), vec3(0.842, 0.528, 0.528), vec3(-0.806, 0.185, 0.185), vec3(0.719, 0.41, 0.41), vec3(-0.111, -0.655, -0.655), vec3(0.463, 0.878, 0.878), 
    vec3(-0.895, 0.33, 0.33), vec3(0.568, -0.174, -0.174), vec3(-0.785, 0.274, 0.274), vec3(0.284, 0.62, 0.62), vec3(-0.196, 0.178, 0.178), vec3(0.357, 0.579, 0.579), 
    vec3(0.143, -0.525, -0.525), vec3(-0.683, -0.367, -0.367), vec3(0.924, 0.193, 0.193), vec3(0.236, 0.362, 0.362), vec3(0.352, 0.202, 0.202), vec3(-0.598, 0.8, 0.8), 
    vec3(-0.585, -0.812, -0.812), vec3(0.896, -0.181, -0.181), vec3(0.645, -0.009, -0.009), vec3(0.383, 0.827, 0.827), vec3(-0.622, -0.307, -0.307), vec3(0.815, -0.551, -0.551), 
    vec3(-0.705, -0.023, -0.023), vec3(-0.722, -0.535, -0.535), vec3(0.173, -0.748, -0.748), vec3(0.124, -0.617, -0.617), vec3(0.175, -0.676, -0.676), vec3(-0.247, 0.452, 0.452), 
    vec3(0.513, -0.707, -0.707), vec3(0.436, 0.885, 0.885), vec3(0.436, 0.672, 0.672), vec3(0.242, 0.33, 0.33), vec3(-0.169, -0.721, -0.721), vec3(0.828, 0.555, 0.555), 
    vec3(0.469, -0.269, -0.269), vec3(0.517, 0.455, 0.455), vec3(-0.608, -0.615, -0.615), vec3(-0.37, 0.837, 0.837), vec3(-0.532, -0.603, -0.603), vec3(-0.837, 0.542, 0.542), 
    vec3(-0.616, -0.069, -0.069), vec3(0.597, -0.294, -0.294), vec3(0.72, -0.693, -0.693), vec3(-0.129, -0.983, -0.983), vec3(-0.576, -0.637, -0.637), vec3(0.379, 0.783, 0.783), 
    vec3(0.893, -0.254, -0.254), vec3(0.105, -0.96, -0.96), vec3(0.705, -0.709, -0.709), vec3(-0.896, -0.091, -0.091), vec3(-0.731, -0.302, -0.302), vec3(0.691, -0.72, -0.72), 
    vec3(0.318, 0.01, 0.01), vec3(-0.434, 0.549, 0.549), vec3(-0.44, -0.855, -0.855), vec3(-0.065, 0.895, 0.895), vec3(-0.03, -0.891, -0.891), vec3(-0.184, 0.669, 0.669), 
    vec3(-0.576, 0.344, 0.344), vec3(-0.43, 0.811, 0.811), vec3(0.551, -0.826, -0.826), vec3(-0.608, 0.554, 0.554), vec3(-0.751, -0.399, -0.399), vec3(0.569, -0.517, -0.517), 
    vec3(-0.103, 0.861, 0.861), vec3(-0.291, -0.68, -0.68), vec3(-0.733, 0.616, 0.616), vec3(0.981, 0.02, 0.02), vec3(0.145, -0.806, -0.806), vec3(0.776, -0.424, -0.424), 
    vec3(0.78, -0.551, -0.551), vec3(0.697, 0.399, 0.399), vec3(0.838, -0.282, -0.282), vec3(0.946, -0.323, -0.323), vec3(0.041, -0.031, -0.031), vec3(0.663, 0.144, 0.144), 
    vec3(-0.668, -0.724, -0.724), vec3(-0.514, 0.855, 0.855), vec3(-0.124, -0.625, -0.625), vec3(0.723, -0.461, -0.461), vec3(0.004, -0.655, -0.655), vec3(-0.79, -0.348, -0.348), 
    vec3(0.371, -0.901, -0.901), vec3(0.05, -0.424, -0.424), vec3(0.638, 0.513, 0.513), vec3(-0.538, -0.419, -0.419), vec3(0.059, -0.998, -0.998), vec3(0.489, 0.869, 0.869), 
    vec3(-0.684, 0.699, 0.699), vec3(-0.901, -0.393, -0.393), vec3(-0.876, 0.48, 0.48), vec3(-0.841, -0.541, -0.541), vec3(0.401, -0.387, -0.387), vec3(-0.688, -0.088, -0.088), 
    vec3(0.123, 0.643, 0.643), vec3(0.815, -0.576, -0.576), vec3(0.628, -0.153, -0.153), vec3(0.166, -0.954, -0.954)
);
