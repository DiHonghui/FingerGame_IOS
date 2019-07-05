//
//  AutoLayout.swift
//  AutoLayout
//
//  Created by javar on 2018/9/6.
//  Copyright © 2018年 da0ke. All rights reserved.
//

import Foundation
import UIKit

public class AutoLayout {
    
    
    //--------------------------------------view 初始化封装 start-----------------------------
    
    public static func view_add(parent:UIView) -> UIView {
        let view = UIView();
        parent.addSubview(view);
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        return view;
    }
    
    public static func label_add(parent:UIView) -> UILabel {
        let view = UILabel();
        parent.addSubview(view);
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        return view;
    }
    
    public static func textfield_add(parent:UIView) -> UITextField {
        let view = UITextField();
        parent.addSubview(view);
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        return view;
    }
    
    public static func textview_add(parent:UIView) -> UITextView {
        let view = UITextView();
        parent.addSubview(view);
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        return view;
    }
    
    public static func imageview_add(parent:UIView) -> UIImageView {
        let view = UIImageView();
        parent.addSubview(view);
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        return view;
    }
    
    public static func button_add(parent:UIView) -> UIButton {
        let view = UIButton(type: .system);
        parent.addSubview(view);
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        return view;
    }
    
    public static func button_add(parent:UIView,type:UIButtonType) -> UIButton {
        let view = UIButton(type: type);
        parent.addSubview(view);
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        return view;
    }
    
    public static func navbar_add(parent:UIView) -> UINavigationBar {
        let view = UINavigationBar();
        parent.addSubview(view);
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        return view;
    }
    
    public static func scroll_add(parent:UIView) -> UIScrollView {
        let view = UIScrollView();
        parent.addSubview(view);
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.showsVerticalScrollIndicator = false;
        
        return view;
    }
    
    public static func activityIndicator_add(parent:UIView) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView();
        parent.addSubview(view);
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        return view;
    }
    
    //--------------------------------------view 初始化封装 end-----------------------------
    
    //--------------------------------------共通元件 start--------------------------------------

    //root view
    public static func layout_root(_self:UIViewController) -> UIView {
        _self.view.backgroundColor = UIColor.white;
        
        let rootView = view_add(parent: _self.view);
        if #available(iOS 11.0, *) {
            rootView.top(v: _self.view.safeAreaLayoutGuide, c: 0)
                .bottom(v: _self.view.safeAreaLayoutGuide, c:0)
                .leading(v: _self.view.safeAreaLayoutGuide, c: 0)
                .trailing(v: _self.view.safeAreaLayoutGuide, c: 0)
                .build();
        } else {
            rootView.top(v: _self.topLayoutGuide, c: 0)
                .bottom(v: _self.bottomLayoutGuide, c: 0)
                .leading(c: 0)
                .trailing(c: 0)
                .build();
        }
        
        return rootView;
    }
    
    //共通元件-导航栏
    public static func getNavBar(_parent:UIView) -> UINavigationBar {
        let navBar = AutoLayout.navbar_add(parent: _parent);
        navBar.top(c: 0).leading(c: 0).trailing(c: 0).height(c: 44).build();
        navBar.barTintColor = UIColor.white;
        
        return navBar;
    }
    
    //共通元件-BarButtonItem（图片）
    public static func getBarButtonItem(image:String,target:Any?,action:Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named:image)?.withRenderingMode(.alwaysOriginal), style: .plain, target: target, action: action);
    }
    
    //共通元件-BarButtonItem-白色（图片）
    public static func getWhiteBarButtonItem(image:String,target:Any?,action:Selector?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: UIImage(named:image)?.withRenderingMode(.alwaysTemplate), style: .plain, target: target, action: action);
        barButtonItem.tintColor = UIColor.white;
        return barButtonItem;
    }
    
    //共通元件-BarButtonItem（文字）
    public static func getBarButtonItem(text:String,target:Any?,action:Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(title: text, style: .plain, target: target, action: action);
    }
    
    //共通元件-BarButtonItem（barButtonSystemItem）
    public static func getBarButtonItem(systemItem:UIBarButtonSystemItem,target:Any?,action:Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action);
    }
    
    public static func layout_scroll(parent:UIView,top:CGFloat,bottom:CGFloat,leading:CGFloat,trailing:CGFloat) -> UIScrollView {
        let view = scroll_add(parent: parent);
        view.top(c: top)
            .bottom(c: bottom)
            .leading(c: leading)
            .trailing(c: trailing)
            .build();
        
        view.showsVerticalScrollIndicator = false;
        
        return view;
    }
    
    public static func layout_scroll(parent:UIView) -> UIScrollView {
        return AutoLayout.layout_scroll(parent: parent, top: 0, bottom: 0, leading: 0, trailing: 0);
    }
    
    public static func layout_scroll(parent:UIView,_top:UIView) -> UIScrollView {
        let _scroll = scroll_add(parent: parent);
        _scroll.top(v: _top, c: 1)
            .leading(c: 0)
            .trailing(c: 0)
            .bottom(c: 0)
            .build();
        
        _scroll.showsVerticalScrollIndicator = false;
        
        return _scroll;
    }
    
    public static func layout_content(_scroll:UIScrollView) -> UIView {
        let _content = view_add(parent: _scroll);
        
        if #available(iOS 11.0, *) {
            _content.top(v: _scroll.contentLayoutGuide, c: 0)
                .leading(v: _scroll.contentLayoutGuide, c: 0)
                .trailing(v: _scroll.contentLayoutGuide, c: 0)
                .bottom(v: _scroll.contentLayoutGuide, c: 0)
                .width(v: _scroll, c: 0)
                .build();
        } else {
            _content.top(c: 0)
                .leading(c: 0)
                .trailing(c: 0)
                .bottom(c: 0)
                .width(v: _scroll, c: 0)
                .build();
        };
        
        return _content;
    }
    
    //--------------------------------------共通元件 end--------------------------------------
    
}


//--------------------------------------约束封装 start-----------------------------

extension UIView {
    
    public func build() {}
    
    
    //top
    public func top(c:CGFloat) -> Self {
        var con:NSLayoutConstraint!;
        if #available(iOS 11.0, *) {
            con = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview?.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: c)
        } else {
            con = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: c);
        };
        superview?.addConstraint(con);
        
        return self;
    }
    public func top(v:UILayoutSupport, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: v, attribute: .bottom, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    @available(iOS 9.0, *)
    public func top(v:UILayoutGuide, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func top(v:UIView, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: v, attribute: .bottom, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func top(relatedBy:NSLayoutRelation,c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .top, relatedBy: relatedBy, toItem: superview, attribute: .top, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func top(relatedBy:NSLayoutRelation,v:UIView,c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .top, relatedBy: relatedBy, toItem: v, attribute: .bottom, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    
    //bottom
    public func bottom(c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func bottom(v:UILayoutSupport, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    @available(iOS 9.0, *)
    public func bottom(v:UILayoutGuide, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: v, attribute: .bottom, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func bottom(v:UIView, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func bottom(relatedBy:NSLayoutRelation,c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: relatedBy, toItem: superview, attribute: .bottom, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    
    //leading
    public func leading(c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        
        return self;
    }
    @available(iOS 9.0, *)
    public func leading(v:UILayoutGuide, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: v, attribute: .leading, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func leading(v:UIView, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: v, attribute: .trailing, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func leading(relatedBy:NSLayoutRelation, v:UIView, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: relatedBy, toItem: v, attribute: .trailing, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    
    //trailing
    public func trailing(c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func trailing(v:UIView, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: v, attribute: .leading, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    @available(iOS 9.0, *)
    public func trailing(v:UILayoutGuide, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: v, attribute: .trailing, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func trailing(relatedBy:NSLayoutRelation,c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: relatedBy, toItem: superview, attribute: .trailing, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func trailing(relatedBy:NSLayoutRelation, v:UIView, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: relatedBy, toItem: v, attribute: .leading, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    
    //width
    public func width(c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .width, multiplier: 1, constant: c);
        self.addConstraint(con);
        return self;
    }
    public func width(v:UIView, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: v, attribute: .width, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func width(mult:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: mult, constant: 0);
        superview?.addConstraint(con);
        return self;
    }
    public func width(mult:CGFloat, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: mult, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func width(v:UIView,mult:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: v, attribute: .width, multiplier: mult, constant: 0);
        superview?.addConstraint(con);
        return self;
    }
    public func width(relatedBy:NSLayoutRelation, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relatedBy, toItem: .none, attribute: .width, multiplier: 1, constant: c);
        self.addConstraint(con);
        return self;
    }
    
    //height
    public func height(c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1, constant: c);
        self.addConstraint(con);
        return self;
    }
    public func height(v:UIView, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: v, attribute: .height, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func height(mult:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: mult, constant: 0);
        superview?.addConstraint(con);
        return self;
    }
    public func height(mult:CGFloat, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: mult, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func height(v:UIView, attr:NSLayoutAttribute) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: v, attribute: attr, multiplier: 1, constant: 0);
        superview?.addConstraint(con);
        return self;
    }
    public func height(relatedBy:NSLayoutRelation, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relatedBy, toItem: .none, attribute: .height, multiplier: 1, constant: c);
        self.addConstraint(con);
        return self;
    }
    
    //centerX
    public func centerX(c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func centerX(v:UIView, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: v, attribute: .centerX, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    
    //centerY
    public func centerY(c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    public func centerY(v:UIView, c:CGFloat) -> Self {
        let con = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: v, attribute: .centerY, multiplier: 1, constant: c);
        superview?.addConstraint(con);
        return self;
    }
    
}
//--------------------------------------约束封装 end-----------------------------

