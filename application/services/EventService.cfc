/**
 * @presideService
 */
component {

    public any function init( ) {

        return this;
    }

    public query function getAllEventDetail(
          required string eventsId
        ,          string activeRegionFilter    = ""
                   string activeCategoryFilter  = ""
        ) {

        var filter = "page.parent_page = '#arguments.eventsId#'";

        if( len( trim( arguments.activeRegionFilter ) ) ) {
            filter &= " AND event_detail_region.region IN ( " & listQualify(arguments.activeRegionFilter, "'" ) & ")";
        }

        if( len( trim( arguments.activeCategoryFilter ) ) ) {
            filter &= " AND event_detail.category IN ( " & listQualify(arguments.activeCategoryFilter, "'" ) & ")";
        }

        var eventDetail = $getPresideObject( "event_detail" ).selectData(
                selectFields = [
                      "event_detail.id"
                    , "page.title"
                    , "page.teaser"
                    , "page.main_image"
                    , "event_detail.event_startdate"
                    , "event_detail.event_enddate"
                    , "event_detail.category"
                    , "category.label as category_label"
                ]
                , filter = filter
                , groupBy = "event_detail.id"
            )


        return eventDetail;
    }

    public query function getRegionFilters() {

        return $getPresideObject( "region" ).selectData(
            selectFields = [ "region.id", "region.label" ]
        );

    }

    public query function getEventCategories(  required string pageId ) {

        var eventCategories = $getPresideObjectService().selectData(
              objectName    = "events_categories"
            , selectFields  = [
                  "category.label"
                , "GROUP_CONCAT(events_categories.category) AS category"
            ]
            , filter        = { "events.id" = pageId }
            , groupBy       = "events_categories.events"

        );

        return eventCategories;
    }

    public query function getFeaturedEvents( required string eventsId ) {

        var featuredEvent  = $getPresideObjectService().selectData(
              objectName   = "event_detail_featured"
            , selectFields = [
                  "event_detail.id"
                , "event_detail$page.title"
                , "event_detail$page.teaser"
                , "event_detail$page.main_image"
                , "event_detail.event_startdate"
                , "event_detail.event_enddate"
            ]
            , filter       = { "event_detail$page.parent_page" = eventsId }
            , orderBy      = "event_detail_featured.sort_order ASC"
        )

        return featuredEvent;
    }


    public query function getCategeryById( required string categoryId ) {

        return "hello";
    }

}