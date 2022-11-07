({
    doInit : function(component, event, helper) {
        console.log('Initialization completed');
        helper.getWords(6);
    },
    doRender : function(component, event, helper) {
        console.log('Render completed');
    },
})
