resource "fortios_user_local" "sslvpnuser_test" {
    name                      = "test"
    status                    = "enable"
    type                      = "password"
    passwd		      = "Welcome.123"
}
