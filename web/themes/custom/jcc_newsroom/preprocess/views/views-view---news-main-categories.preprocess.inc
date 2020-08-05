<?php

/**
 * @file
 * Preprocessors for views.
 */

use Drupal\Core\Entity\Entity\EntityViewDisplay;

/**
 * Implements hook_preprocess_HOOK().
 */
function jcc_newsroom_preprocess_views_view__news_main_categories(&$variables) {
  foreach ($variables['rows'][0]['#rows'] as $row) {
    $node = $row['#node'];

    $date = date("F j, Y", $node->getCreatedTime());

    $summary = $node->body->view(
      [
        'label' => 'hidden',
        'type' => 'text_summary_or_trimmed',
        'settings' => [
          'trim_length' => 600,
        ],
      ]
    );
    $summary_markup = render($summary);
    $summary = [];

    $tags_markup = '';
    foreach (['field_division', 'field_tags', 'field_subject_matter'] as $tag) {
      $display_options = EntityViewDisplay::collectRenderDisplay($node, 'teaser')
        ->getComponent($tag);
      $tag_render = [];
      $tag_render = $node->$tag->view($display_options);
      $tags_markup .= render($tag_render);
    }

    $excerpt['#markup'] = <<<TEMPLATE
<div class="created">{$date}</div>
<div class="teaser-text">{$summary_markup}</div>
<div class="jcc-tags">
  {$tags_markup}
</div>
TEMPLATE;

    $image_url = $image_alt = "";
    if (!$node->get('field_images')->isEmpty()) {
      $image_url = file_create_url(
        $node->get('field_images')->entity->get('field_media_image')
          ->first()->entity->uri->value
      );
      $image_alt = $node->get('field_images')->entity->get('field_media_image')
        ->first()->alt;
    }

    $variables['tiles_list']['tiles'][] = [
      'card' => [
        'title' => $node->getTitle(),
        'excerpt' => render($excerpt),
        'url' => $node->toUrl(),
      ],
      'date' => '',
      'img' => [
        'src' => $image_url,
        'alt' => $image_alt,
        'renderer' => 'patternlab',
      ],
    ];

    $excerpt = [];
  }
}