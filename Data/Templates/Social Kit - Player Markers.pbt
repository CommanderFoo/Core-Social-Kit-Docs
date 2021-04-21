Assets {
  Id: 3341810104184040756
  Name: "Social Kit - Player Markers"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 18081043883446291330
      Objects {
        Id: 18081043883446291330
        Name: "Social Kit - Player Markers"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4781671109827199097
        ChildIds: 8426207910044194852
        ChildIds: 16952357958165182666
        UnregisteredParameters {
          Overrides {
            Name: "cs:key_press_mark"
            String: "m"
          }
          Overrides {
            Name: "cs:key_press_hide_all"
            String: "h"
          }
          Overrides {
            Name: "cs:marker"
            AssetReference {
              Id: 3557533177808511910
            }
          }
          Overrides {
            Name: "cs:show_distance"
            Bool: true
          }
          Overrides {
            Name: "cs:marker_color"
            Color {
              R: 1
              G: 1
              A: 1
            }
          }
          Overrides {
            Name: "cs:distance_color"
            Color {
              R: 1
              G: 1
              A: 1
            }
          }
          Overrides {
            Name: "cs:random_color"
            Bool: true
          }
          Overrides {
            Name: "cs:marker_y_offset"
            Int: 50
          }
          Overrides {
            Name: "cs:marker_x_offset"
            Int: 0
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Folder {
          IsFilePartition: true
          FilePartitionName: "Social Kit - Player Waypoints"
        }
      }
      Objects {
        Id: 8426207910044194852
        Name: "Client"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 18081043883446291330
        ChildIds: 7314928777286490140
        ChildIds: 8225407034519937936
        Collidable_v2 {
          Value: "mc:ecollisionsetting:forceoff"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        NetworkContext {
        }
      }
      Objects {
        Id: 7314928777286490140
        Name: "Social_Kit_Player_Markers_Client"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 8426207910044194852
        UnregisteredParameters {
          Overrides {
            Name: "cs:ui_container"
            ObjectReference {
              SubObjectId: 8225407034519937936
            }
          }
        }
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Script {
          ScriptAsset {
            Id: 10302983985505691535
          }
        }
      }
      Objects {
        Id: 8225407034519937936
        Name: "UI Container"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 8426207910044194852
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Control {
          RenderTransformPivot {
            Anchor {
              Value: "mc:euianchor:middlecenter"
            }
          }
          Canvas {
          }
          AnchorLayout {
            SelfAnchor {
              Anchor {
                Value: "mc:euianchor:topleft"
              }
            }
            TargetAnchor {
              Anchor {
                Value: "mc:euianchor:topleft"
              }
            }
          }
        }
      }
      Objects {
        Id: 16952357958165182666
        Name: "Server"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 18081043883446291330
        ChildIds: 4166987838005701818
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        NetworkContext {
          Type: Server
        }
      }
      Objects {
        Id: 4166987838005701818
        Name: "Social_Kit_Player_Markers_Server"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 16952357958165182666
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        Script {
          ScriptAsset {
            Id: 16621274118751636852
          }
        }
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  SerializationVersion: 73
  DirectlyPublished: true
}
