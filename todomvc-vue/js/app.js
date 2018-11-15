;(function () {
    var todos = [
    {
        id : 1,
        title : 'eat',
        completed : true,
    },
    {
        id : 2,
        title : 'sleep',
        completed : false,
    },
    {
        id : 3,
        title : 'code',
        completed : false,
    },
    ]

    new Vue({
        data:{
            todos,
        },
        methods: {
            handleNewTodoKeyDown(e){
                var value = e.target.value.trim()
                if (!value.length) {
                    e.target.value =''
                    return
                }
                this.todos.push({
                    id: todos[this.todos.length - 1].id + 1,
                    title:value,
                    completed:false,
                })
                e.target.value =''
            },
            handleToggleAllChange(e){
                var checked = e.target.checked
                todos.forEach(item =>{
                    item.completed = checked
                })
            }
        },

    }).$mount('#app')

})();           
