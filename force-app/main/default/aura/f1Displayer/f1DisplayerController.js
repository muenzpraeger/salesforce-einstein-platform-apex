({
    doInit : function(component) {
        if ($A.util.isArray(component.get("v.f1"))){
            component.set("v.f1Type", "array");
        } else {
            component.set("v.f1Type", "number");
        }
    }
})
