({
    startGame : function(component, event, helper) {

        let gameModeCombobox =  component.find("gameMode");
        let selectedValue = gameModeCombobox.get("v.value");

        component.set("v.selectedMode", selectedValue);

        console.log("The start new game button was clicked, The Game Mode is: ", selectedValue);
        
        console.log(component.get("v.selectedMode"));
    },

    reshuffleBoard: function(component, event, helper) {
        console.log("Reshuffle board is called");
    }
})
