function createData() {
    var data = {
        yAxis: "# of samples in each direction while maintaining 60 fps",
        maxValue: 35,
        sections: [
            "Gaussian Blur, two pass"
        ],
        sets: [],
    }

    data.sets.push({
        label: "Intel-i7 kwin no-comp Nvidia-GT210 1920x1080",
        sections: [7]
    });
    data.sets.push({
        label: "MacBookPro early-2011 intel-gpu 1650x1050",
        sections: [7]
    });
    data.sets.push({
        label: "MacBookPro early-2011 amd-gpu 1650x1050",
        sections: [32]
    });
    data.sets.push({
        label: "iPad retina-mini 2048x1536",
        sections: [3]
    });
    data.sets.push({
        label: "Jolla Adreno305 540x960",
        sections: [0]
    });
    data.sets.push({
        label: "Intel-i7 kwin comp Nvidia-GT210 1920x1080",
        sections: [0]
    });
    data.sets.push({
        label: "Intel-i7 unity comp Nvidia-GT210 1920x1080",
        sections: [3]
    });

    return data;
}
