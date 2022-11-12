({
    doInit : function(component, event, helper) {
        console.log('Initialization completed');

        let column = 0;

        const gameMode = component.get("v.mode");
        
        if(gameMode && gameMode === "hard") {
            column = 6;
        } else if(gameMode === "medium") {
            column = 4;
        } else {
            column = 3;
        }

        let blockSize = 12/column;
        component.set("v.blockSize", blockSize);

        const words = helper.getWords(column*column); 
        component.set("v.words", words);

        component.set("v.winWord", helper.getWinWord(words));
    },
    doRender : function(component, event, helper) {
        console.log('Render completed');
    },
})
