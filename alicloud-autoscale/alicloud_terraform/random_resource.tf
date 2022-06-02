//Create a Random String to be used for the PSK secret.
resource "random_string" "psk" {
    length = 16
    special = true
    override_special = ""
}
//Random 3 char string appended to the ened of each name to avoid conflicts
//If you increase this number you will need to adjust OTS name since it will exceed the max 16 chars.
resource "random_string" "random_name_post" {
    length = 3
    special = true
    override_special = ""
    min_lower = 3
}
