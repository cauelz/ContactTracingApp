({
    startGame : function(component, event, helper) {

        let gameModeCombobox =  component.find("gameMode");
        let selectedValue = gameModeCombobox.get("v.value");

        component.set("v.selectedMode", selectedValue);

    },

    reshuffleBoard: function(component, event, helper) {
        console.log("Reshuffle board is called");
    }
})
