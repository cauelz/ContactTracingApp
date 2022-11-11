({
    doInit : function(component, event, helper) {
        console.log('Initialization completed');
        const words = helper.getWords(6); 
        component.set("v.words", words);
        console.log('Words: ' + words);
        console.log('Win Word: ' + helper.getWinWord(words));
        component.set("v.winWord", helper.getWinWord(words));
    },
    doRender : function(component, event, helper) {
        console.log('Render completed');
    },
})
