<li ng-class="{
		active: isFeedActive(feedType.Subscriptions, 0),
		unread: getUnreadCount(feedType.Subscriptions, 0)!=0
	}" 
	ng-show="isShown(feedType.Subscriptions, 0)">
	<a class="rss-icon" 
	   href="#" 
	   ui-if="!isShowAll()"
	   ng-click="loadFeed(feedType.Subscriptions, 0)">
	   <?php p($l->t('Unread articles'))?>
	</a>
		<a class="rss-icon" 
	   href="#" 
	   ui-if="isShowAll()"
	   ng-click="loadFeed(feedType.Subscriptions, 0)">
	   <?php p($l->t('All articles'))?>
	</a>
	<span class="utils">
		<span class="unread-counter">
			{{ getUnreadCount() }}
		</span>
		<button class="svg action mark-read-icon" 
			ng-click="feedBl.markAllRead()"
			title="<?php p($l->t('Mark all read')) ?>"></button>
	</span>
</li>