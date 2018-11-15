/**
 * Created by new on 2017/5/23.
 */
$(document).ready(function () {

    $.jgrid.defaults.styleUI = 'Bootstrap';
    
    $.jgrid.useJSON = true;
    
    var mydata = [
        {
            grade: "13",
            playerNum: "南北",
            rate: "区属",
            averagePay: "马连道路",
            registerDays: "广安门外大街",
            averagePlayTimes: "红莲南路",
            skillLevel:"大栅栏街道办",
            adjutantStars:"西城区市政市容管理委员会",
            usualHero:"次干路",
            averageWinRate:"双幅路",
            activeRate:"无"
        },
    ];
    $("#table_list_2").jqGrid({
    	data: mydata,
        url:"<%=basePath%>"+"AddRoadServlet",
        editurl:"<%=basePath%>"+"AddRoadEditServlet",
    	//datatype:"json",
        datatype: "local",
        height: 400,
        mtype:"GET",
        autowidth: true,
        shrinkToFit: true,
        rowNum: 15,
        rowList: [10, 15, 20],
        colNames: ['分段', '玩家数', '占比', '平均付费', '注册天数', '平均场次', '技能等级', '副官星数', '常用英雄', '平均胜率', '活跃比'],
        colModel: [
            {
                name: 'grade',
                index: 'grade',
                editable: true,
                width: 20,
                sorttype: "int",
                search: true,
                align: "center"
            },
            {
                name: 'playerNum',
                index: 'playerNum',
                editable: true,
                width: 20,
                align: "center"
            },
            {
                name: 'rate',
                index: 'rate',
                editable: true,
                width: 35,
                align: "center"
            },
            {
                name: 'averagePay',
                index: 'averagePay',
                editable: true,
                width: 45,
                align: "center"
            },
            {
                name: 'registerDays',
                index: 'registerDays',
                editable: true,
                width: 40,
                align: "center"
            },
            {
                name: 'averagePlayTimes',
                index: 'averagePlayTimes',
                align: "center",
                editable: true,
                width:40,
                sortable: false
            },
            {
                name: 'skillLevel',
                index: 'skillLevel',
                editable: true,
                width: 50,
                align: "center"
            },
            {
                name: 'adjutantStars',
                index: 'adjutantStars',
                editable: true,
                width: 60,
                align: "center"
            },
            {
                name: 'usualHero',
                index: 'usualHero',
                editable: true,
                width: 25,
                align: "center"
            },
            {
                name: 'averageWinRate',
                index: 'averageWinRate',
                editable: true,
                width: 25,
                align: "center"
            },
            {
                name: 'activeRate',
                index: 'activeRate',
                editable: true,
                width: 30,
                align: "center"
            }
        ],
        pager: "#pager_list_2",
        altRows:true,
        viewrecords: true,
        caption: "分段统计",
        add: true,
        edit: true,
        addtext: 'Add',
        edittext: 'Edit',
        hidegrid: false
    });

    // Add selection
    $("#table_list_2").setSelection(4, true);


    // Setup buttons
    $("#table_list_2").jqGrid('navGrid', '#pager_list_2', {
        edit: true,
        add: true,
        del: true,
        search: true,
        refresh:true
    }, {
        height: 200,
        reloadAfterSubmit: true
    });

    // Add responsive to jqGrid
    $(window).bind('resize', function () {
        var width = $('.jqGrid_wrapper').width();
        $('#table_list_2').setGridWidth(width);
    });
});