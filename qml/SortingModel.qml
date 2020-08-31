import QtQuick 2.5
import QtQml.Models 2.1

DelegateModel {
    id: visualModel

    function lessThan(left, right) {
        var leftTitle = left.title ? left.title : left.fullName
        var rightTitle = right.title ? right.title : right.fullName
        return leftTitle.localeCompare(rightTitle) < 0;
    }

    function insertPosition(item) {
        var lower = 0
        var upper = items.count
        while (lower < upper) {
            var middle = Math.floor(lower + (upper - lower) / 2)
            var result = lessThan(item, items.get(middle).model);
            if (result) {
                upper = middle
            } else {
                lower = middle + 1
            }
        }
        return lower
    }

    items.includeByDefault: false

    groups: [
        DelegateModelGroup {
            id: itemsGroup
            name: "items"
            includeByDefault: false
        }
    ]

    function sort() {
        var rowCount = model.count;

        for(var i = 0; i < rowCount; ++i) {
            var entry = model.get(i);

            if(!entry.phoneNumber1)
                continue;

            var index = insertPosition(entry)
            items.insert(entry, "items");
            items.move(items.count-1, index)
        }
    }
}
