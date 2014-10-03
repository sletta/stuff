function createData() {
    var data = {
        yAxis: "# overdraws per frame while maintaining 60 fps",
        maxValue: 100,
        sections: [
            "Opaque Rectangles",
            "Blended Rectangles",
            "Opaque Textures",
            "Blended Textures"
        ],
        sets: [],
    }

    data.sets.push({
        label: "Intel-i7 kwin no-comp Nvidia-GT210 1920x1080",
        sections: [1000, 7, 350, 4]
    });
    data.sets.push({
        label: "MacBookPro early-2011 intel-gpu 1650x1050",
        sections: [200, 10, 50, 8]
    });
    data.sets.push({
        label: "MacBookPro early-2011 amd-gpu 1650x1050",
        sections: [320, 38, 120, 28]
    });
    data.sets.push({
        label: "iPad retina-mini 2048x1536",
        sections: [50, 10, 30, 8]
    });
    data.sets.push({
        label: "Jolla Adreno305 540x960",
        sections: [43, 18, 34, 12]
    });
    data.sets.push({
        label: "Intel-i7 kwin comp Nvidia-GT210 1920x1080",
        sections: [12, 3, 8, 2]
    });
    data.sets.push({
        label: "Intel-i7 unity comp Nvidia-GT210 1920x1080",
        sections: [16, 5, 12, 3]
    });

    return data;
}
