const displayWhenSelected = (options, value, target) => {
    const selectedIndex = options.selectedIndex;
    const isSelected = options[selectedIndex].value === value;
    target.classList[isSelected
        ? "add"
        : "remove"
    ]("show");
};

export {displayWhenSelected};
