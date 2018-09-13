

#prmark mark - header footer
//设定头部的大小  仅限ios9canScroll  否则会崩掉
//Assertion failure in _createPreparedSupplementaryViewForElementOfKind
layout.headerReferenceSize = CGSizeMake(KScreenWidth, QuotesListSelfGridCollectionHeaderViewHeight);
//设定头部的大小  ios9以下
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(KScreenWidth, QuotesSelfGridCollectionHeaderHeight);
}
layout.sectionHeadersPinToVisibleBounds = YES;
layout.sectionFootersPinToVisibleBounds = YES;

#prmark mark - other
当collectionView的高度与tableViewCell的高度相同 并且collectionView的contentSize（即可滑动部分）的高度与collectionView的高度相同时 滑动collectionView时会滑动外面的tableView

