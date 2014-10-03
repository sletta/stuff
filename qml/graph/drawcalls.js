function createData() {
    var data = {
        yAxis: "# of glDrawXxx calls per frame while maintaining 60 fps",
        maxValue: 1500,
        sections: [
            "glDrawXxx calls"
        ],
        sets: [],
    }

    data.sets.push({
        label: "Intel-i7 kwin no-comp Nvidia-GT210 1920x1080",
        sections: [1500]
    });
    data.sets.push({
        label: "MacBookPro early-2011 intel-gpu 1650x1050",
        sections: [1000]
    });
    data.sets.push({
        label: "MacBookPro early-2011 amd-gpu 1650x1050",
        sections: [1500]
    });
    data.sets.push({
        label: "iPadMini retina 2048x1536",
        sections: [900]
    });
    data.sets.push({
        label: "Jolla Adreno305 540x960",
        sections: [900]
    });
    data.sets.push({
        label: "Intel-i7 kwin comp Nvidia-GT210 1920x1080",
        sections: [300]
    });
    data.sets.push({
        label: "Intel-i7 unity comp Nvidia-GT210 1920x1080",
        sections: [300]
    });

    return data;
}
