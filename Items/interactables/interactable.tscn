[gd_scene format=3 uid="uid://r8g8upfpqh4m"]

[ext_resource type="Script" uid="uid://cx7w254s742ua" path="res://Items/interactables/interactable.gd" id="1_tirr5"]
[ext_resource type="Texture2D" uid="uid://1j0xo782toyr" path="res://icon.svg" id="2_6splr"]

[sub_resource type="BoxShape3D" id="BoxShape3D_i164k"]

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_hxiek"]
albedo_texture = ExtResource("2_6splr")

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_gnxum"]
metallic = 1.0
metallic_specular = 1.0

[sub_resource type="BoxMesh" id="BoxMesh_ts348"]
material = SubResource("StandardMaterial3D_gnxum")

[node name="Interactable" type="Area3D" unique_id=1489411329]
script = ExtResource("1_tirr5")

[node name="CollisionShape3D" type="CollisionShape3D" parent="." unique_id=373215807]
shape = SubResource("BoxShape3D_i164k")

[node name="MeshInstance3D" type="MeshInstance3D" parent="." unique_id=112494385]
material_override = SubResource("StandardMaterial3D_hxiek")
mesh = SubResource("BoxMesh_ts348")
