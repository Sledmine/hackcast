// Fake iezvu server for EZCast (Flash Tool) to download firmware
// Known dongle models:
//
//sage_8268B_anycast-dongle_WifiDisplay8MFree
//sage_8268B_anycast-dongle_WifiDisplay8Mkey
//am_8268B_anycast-dongle_8MFree
//am_8268B_anycast-dongle_8Mkey
//sage_8268B_mirascreen-dongle_8Mkey-8723as (that one with internal 8723as wifi chip)
//sage_8268B_mirascreen-dongle_8Mkey???
//sage_8268B_mirascreen-dongle_8MFree???

const fakeResponse = {
  ota_conf_file: 'http://cdn.iezcast.com/upgrade/sage_8268B_mirascreen-dongle_8MFree/official/sage_8268B_mirascreen-dongle_8MFree_official-19028035.conf',
  ota_fw_file: 'http://cdn.iezcast.com/upgrade/sage_8268B_mirascreen-dongle_8MFree/official/sage_8268B_mirascreen-dongle_8MFree_official-19028035-0x3DBB75D8.gz',
  ota_enforce: false,
  safety_ota_conf_file: 'https://cdn.iezcast.com/upgrade/sage_8268B_mirascreen-dongle_8MFree/official/sage_8268B_mirascreen-dongle_8MFree_official-19028035.conf',
  safety_ota_fw_file: 'https://cdn.iezcast.com/upgrade/sage_8268B_mirascreen-dongle_8MFree/official/sage_8268B_mirascreen-dongle_8MFree_official-19028035-0x3DBB75D8.gz',
}

const server = Bun.serve({
  port: 8080,
  async fetch(request) {
    console.log(request)
    console.log(await request.json())
    const response = new Response(JSON.stringify(fakeResponse))
    return response
  }
})

console.log(`Listening on ${server.url}`)

