/*-----------------data config start  -------------------*/

#include "qcloud_iot_export_data_template.h"


#define TOTAL_PROPERTY_COUNT 2

static sDataPoint    sg_DataTemplate[TOTAL_PROPERTY_COUNT];

typedef struct _ProductDataDefine {
    TYPE_DEF_TEMPLATE_BOOL m__mesh_generic_onoff;
    TYPE_DEF_TEMPLATE_STRING m_uid[20+1];
} ProductDataDefine;

static   ProductDataDefine     sg_ProductData;

static void _init_data_template(void)
{
    sg_ProductData.m__mesh_generic_onoff = 0;
    sg_DataTemplate[0].data_property.data = &sg_ProductData.m__mesh_generic_onoff;
    sg_DataTemplate[0].data_property.key  = "_mesh_generic_onoff";
    sg_DataTemplate[0].data_property.type = TYPE_TEMPLATE_BOOL;
    sg_DataTemplate[0].state = eCHANGED;

    sg_ProductData.m_uid[0] = '\0';
    sg_DataTemplate[1].data_property.data = sg_ProductData.m_uid;
    sg_DataTemplate[1].data_property.data_buff_len = sizeof(sg_ProductData.m_uid)/sizeof(sg_ProductData.m_uid[1]);
    sg_DataTemplate[1].data_property.key  = "uid";
    sg_DataTemplate[1].data_property.type = TYPE_TEMPLATE_STRING;
    sg_DataTemplate[1].state = eCHANGED;

};
