<?php

namespace Drupal\jcc_video_embed_granicus\Plugin\video_embed_field\Provider;

use Drupal\video_embed_field\ProviderPluginBase;

/**
 * A Granicus provider plugin.
 *
 * @VideoEmbedProvider(
 *   id = "granicus",
 *   title = @Translation("Granicus")
 * )
 */
class Granicus extends ProviderPluginBase {

  /**
   * {@inheritdoc}
   */
  public function renderEmbedCode($width, $height, $autoplay) {
    return [
      '#type' => 'html_tag',
      '#tag' => 'embed',
      '#attributes' => [
        'width' => $width,
        'height' => $height,
        'frameborder' => '0',
        'allowfullscreen' => 'allowfullscreen',
        'src' => sprintf('//jcc.granicus.com/player/event/%s?&autostart=%d&embed=1', $this->getVideoId(), $autoplay),
      ],
    ];
  }

  /**
   * {@inheritdoc}
   */
  public function getRemoteThumbnailUrl() {
    return sprintf('https://jcc.granicus.com/player/event/%s', $this->getVideoId());
  }

  /**
   * {@inheritdoc}
   */
  public static function getIdFromInput($input) {
    preg_match('/^https?:\/\/jcc.granicus.com\/(player\/[a-zA-Z0-9]*\/)?(?<id>[0-9]*)(\/[a-zA-Z0-9]+)?(\#t=(\d+)s)?$/', $input, $matches);
    return isset($matches['id']) ? $matches['id'] : FALSE;
  }

}