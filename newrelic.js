/**
 * New Relic agent configuration.
 *
 * See lib/config.defaults.js in the agent distribution for a more complete
 * description of configuration variables and their potential values.
 */
exports.config = {
  /**
   * Array of application names.
   */
  app_name: ['gitignore.io'],
  /**
   * Your New Relic license key.
   */
  license_key: 'license key here',
  /**
   * Whether to capture parameters in the request URL in slow transaction
   * traces and error traces. Because this can pass sensitive data, it's
   * disabled by default. If there are specific parameters you want ignored,
   * use ignored_params.
   *
   * @env NEW_RELIC_CAPTURE_PARAMS
   */
  capture_params: true,
  logging: {
    /**
     * Level at which to log. 'trace' is most useful to New Relic when diagnosing
     * issues with the agent, 'info' and higher will impose the least overhead on
     * production applications.
     */
    level: 'info'
  }
}
