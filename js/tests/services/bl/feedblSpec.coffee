###

ownCloud - News

@author Bernhard Posselt
@copyright 2012 Bernhard Posselt nukeawhale@gmail.com

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU AFFERO GENERAL PUBLIC LICENSE
License as published by the Free Software Foundation; either
version 3 of the License, or any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU AFFERO GENERAL PUBLIC LICENSE for more details.

You should have received a copy of the GNU Affero General Public
License along with this library.  If not, see <http://www.gnu.org/licenses/>.

###


describe '_FeedBl', ->


	beforeEach module 'News'

	beforeEach inject (@_FeedBl, @FeedModel, @ItemModel, @_ItemBl) =>
		@persistence =
			getItems: ->

		@itemBl = new _ItemBl(@ItemModel, @persistence)

		@bl = new @_FeedBl(@FeedModel, @itemBl, @persistence)


	it 'should return the number of unread feeds', =>
		@FeedModel.add({id: 3, unreadCount:134, urlHash: 'a1'})
		count = @bl.getUnreadCount(3)

		expect(count).toBe(134)


	it 'should return all feeds of a folder', =>
		feed1 = {id: 3, unreadCount:134, urlHash: 'a1', folderId: 3}
		feed2 = {id: 4, unreadCount:134, urlHash: 'a2', folderId: 2}
		feed3 = {id: 5, unreadCount:134, urlHash: 'a3', folderId: 3}
		@FeedModel.add(feed1)
		@FeedModel.add(feed2)
		@FeedModel.add(feed3)

		feeds = @bl.getFeedsOfFolder(3)

		expect(feeds).toContain(feed1)
		expect(feeds).toContain(feed3)


	it 'should get the correct unread count for folders', =>
		@FeedModel.add({id: 3, unreadCount:134, folderId: 3, urlHash: 'a1'})
		@FeedModel.add({id: 5, unreadCount:2, folderId: 2, urlHash: 'a2'})
		@FeedModel.add({id: 1, unreadCount:12, folderId: 5, urlHash: 'a3'})
		@FeedModel.add({id: 2, unreadCount:35, folderId: 3, urlHash: 'a4'})
		count = @bl.getFolderUnreadCount(3)

		expect(count).toBe(169)


	it 'should delete feeds', =>
		@FeedModel.removeById = jasmine.createSpy('remove')
		@persistence.deleteFeed = jasmine.createSpy('deletequery')
		@bl.delete(3)

		expect(@FeedModel.removeById).toHaveBeenCalledWith(3)
		expect(@persistence.deleteFeed).toHaveBeenCalledWith(3)



	it 'should mark feed as read', =>
		@persistence.setFeedRead = jasmine.createSpy('setFeedRead')
		@FeedModel.add({id: 5, unreadCount:2, folderId: 2, urlHash: 'a1'})
		@ItemModel.add({id: 6, feedId: 5, guidHash: 'a1'})
		@ItemModel.add({id: 3, feedId: 5, guidHash: 'a2'})
		@ItemModel.add({id: 2, feedId: 5, guidHash: 'a3'})
		@bl.markFeedRead(5)

		expect(@persistence.setFeedRead).toHaveBeenCalledWith(5, 6)
		expect(@FeedModel.getById(5).unreadCount).toBe(0)


	it 'should mark all as read', =>
		@persistence.setFeedRead = jasmine.createSpy('setFeedRead')
		@FeedModel.add({id: 3, unreadCount:134, folderId: 3, urlHash: 'a1'})
		@FeedModel.add({id: 5, unreadCount:2, folderId: 2, urlHash: 'a2'})
		@FeedModel.add({id: 1, unreadCount:12, folderId: 3, urlHash: 'a3'})

		@bl.markAllRead()

		expect(@FeedModel.getById(3).unreadCount).toBe(0)
		expect(@FeedModel.getById(1).unreadCount).toBe(0)
		expect(@FeedModel.getById(5).unreadCount).toBe(0)


	it 'should get the correct unread count for subscribtions', =>
		@FeedModel.add({id: 3, unreadCount:134, urlHash: 'a1'})
		@FeedModel.add({id: 5, unreadCount:2, urlHash: 'a2'})
		count = @bl.getUnreadCount()

		expect(count).toBe(136)